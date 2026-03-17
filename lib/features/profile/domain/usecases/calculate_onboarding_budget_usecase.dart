import 'dart:math';

import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_entity.dart';

class FixedCostCalculationItem {
  final FixedCostEntity fixedCost;
  final int scaledAmount;

  const FixedCostCalculationItem({
    required this.fixedCost,
    required this.scaledAmount,
  });
}

class OnboardingBudgetCalculationResult {
  final int remainingDays;
  final List<FixedCostCalculationItem> validFixedCosts;
  final int totalFixedCost;
  final int dailyBudgetBruto;
  final int projectedSavings;
  final int recommendedDailyBudget;

  const OnboardingBudgetCalculationResult({
    required this.remainingDays,
    required this.validFixedCosts,
    required this.totalFixedCost,
    required this.dailyBudgetBruto,
    required this.projectedSavings,
    required this.recommendedDailyBudget,
  });
}

class CalculateOnboardingBudgetUseCase {
  OnboardingBudgetCalculationResult execute(
    FinancialProfileEntity profile, {
    DateTime? now,
  }) {
    final referenceDate = now ?? DateTime.now();

    // Sisa hari dihitung termasuk hari ini.
    final dynamicRemainingDays = profile.budgetCycle == BudgetCycle.weekly
        ? _remainingDaysInWeek(referenceDate)
        : _remainingDaysInMonth(referenceDate);

    final safeRemainingDays = max(dynamicRemainingDays, 1);
    final initialBalance = profile.initialBalance;
    final safetyCeiling = profile.safetyCeiling;

    final validFixedCosts = profile.fixedCosts
        .map((item) {
          final occurrences = _countFixedCostOccurrences(
            item: item,
            now: referenceDate,
            remainingDays: safeRemainingDays,
          );

          if (occurrences == 0) {
            return null;
          }

          return FixedCostCalculationItem(
            fixedCost: item,
            // Item mingguan bisa muncul lebih dari sekali dalam sisa siklus bulanan.
            scaledAmount: item.amount * occurrences,
          );
        })
        .whereType<FixedCostCalculationItem>()
        .toList(growable: false);

    final totalFixedCost = validFixedCosts.fold<int>(
      0,
      (sum, item) => sum + item.scaledAmount,
    );

    final dailyBudgetBruto =
        (initialBalance - totalFixedCost) ~/ safeRemainingDays;

    final projectedSavings = max(
      initialBalance - totalFixedCost - (safetyCeiling * safeRemainingDays),
      0,
    );

    return OnboardingBudgetCalculationResult(
      remainingDays: dynamicRemainingDays,
      validFixedCosts: validFixedCosts,
      totalFixedCost: totalFixedCost,
      dailyBudgetBruto: dailyBudgetBruto,
      projectedSavings: projectedSavings,
      recommendedDailyBudget: max(dailyBudgetBruto, 0),
    );
  }

  int _remainingDaysInMonth(DateTime date) {
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0).day;
    return lastDayOfMonth - date.day + 1;
  }

  int _remainingDaysInWeek(DateTime date) {
    final daysUntilEndOfWeek = DateTime.daysPerWeek - date.weekday;
    return daysUntilEndOfWeek + 1;
  }

  int _countFixedCostOccurrences({
    required FixedCostEntity item,
    required DateTime now,
    required int remainingDays,
  }) {
    if (item.cycle == 'weekly') {
      return _countWeekdayOccurrences(
        currentWeekday: now.weekday,
        targetWeekday: item.dueValue,
        remainingDays: remainingDays,
      );
    }

    // Fixed cost bulanan maksimal terjadi satu kali pada jendela sisa saat ini.
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
    final isInRemainingRange =
        item.dueValue >= now.day && item.dueValue <= lastDayOfMonth;

    return isInRemainingRange ? 1 : 0;
  }

  int _countWeekdayOccurrences({
    required int currentWeekday,
    required int targetWeekday,
    required int remainingDays,
  }) {
    // Validasi due value agar tetap di rentang weekday yang valid [1..7].
    if (targetWeekday < 1 || targetWeekday > DateTime.daysPerWeek) {
      return 0;
    }

    // Jarak hari dari hari ini ke kemunculan pertama target weekday.
    final daysUntilFirst =
        (targetWeekday - currentWeekday) % DateTime.daysPerWeek;
    // Karena hari ini ikut dihitung, offset valid adalah [0..remainingDays-1].
    final maxOffset = remainingDays - 1;
    if (daysUntilFirst > maxOffset) {
      return 0;
    }

    // Setelah kemunculan pertama, weekday yang sama berulang tiap 7 hari.
    final daysAfterFirst = maxOffset - daysUntilFirst;
    final extraOccurrences = (daysAfterFirst / DateTime.daysPerWeek).floor();
    return 1 + extraOccurrences;
  }
}
