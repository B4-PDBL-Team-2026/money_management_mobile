import 'dart:math';

import 'package:money_management_mobile/features/dashboard/domain/entities/unpaid_fixed_cost_entity.dart';
import 'package:money_management_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/calculate_financial_profile_usecase.dart';

class CalculateDashboardMetricsUsecase {
  final DashboardRepository _dashboardRepository;

  CalculateDashboardMetricsUsecase(this._dashboardRepository);

  Future<DashboardMetricsResult> execute() async {
    final budgetSnapshot = await _dashboardRepository.getBudgetSnapshot();

    final now = budgetSnapshot.timestamp;
    final balance = budgetSnapshot.balance;
    final todaySpent = budgetSnapshot.todaySpent;
    final actualDailyAllowance = budgetSnapshot.actualDailyAllowance;
    final safetyCeiling = budgetSnapshot.safetyCeiling;
    final safetyFlooring = budgetSnapshot.safetyFlooring;
    final unpaidFixedCosts = budgetSnapshot.unpaidFixedCosts;
    final tomorrowLimitPrediction = budgetSnapshot.tomorrowLimitPrediction;

    final remainingDaysInCycle = max(
      budgetSnapshot.budgetCycle == FinancialCycle.monthly
          ? _remainingDaysInMonth(now)
          : _remainingDaysInWeek(now),
      1,
    );

    final totalUnpaidFixedCost = _calculateTotalUnpaidFixedCost(
      unpaidFixedCosts,
    );

    final safeBalance = max(balance - totalUnpaidFixedCost, 0);

    final scenario = _resolveScenario(
      actualDailyBudget: actualDailyAllowance,
      totalUnpaidFixedCost: totalUnpaidFixedCost,
      safetyCeiling: safetyCeiling,
      safetyFlooring: safetyFlooring,
    );

    final startOfDaySafeBalance = max(
      balance + todaySpent - totalUnpaidFixedCost,
      0,
    );
    final staticActualDailyAllowance =
        startOfDaySafeBalance ~/ remainingDaysInCycle;

    late int limit;
    late String limitName;
    DashboardLimitState limitState = DashboardLimitState.underFirstLimit;
    late DashboardMetric firstMetric;
    late DashboardMetric secondMetric;

    switch (scenario) {
      case BudgetHealthScenario.surplus:
        final futureBudget = safetyCeiling * (remainingDaysInCycle - 1);
        final todayRemainingBudget = max(safetyCeiling - todaySpent, 0);
        final projectedSavings = max(
          safeBalance - futureBudget - todayRemainingBudget,
          0,
        );

        secondMetric = DashboardMetric(
          name: 'Proyeksi Tabungan',
          value: projectedSavings,
          type: MetricType.currency,
        );

        if (todaySpent <= safetyCeiling) {
          limit = safetyCeiling;
          limitName = 'Batas optimal';
          firstMetric = DashboardMetric(
            name: 'Sisa Target',
            value: limit - todaySpent,
            type: MetricType.currency,
          );
        } else {
          limit = staticActualDailyAllowance;
          limitName = 'Batas harian aktual';

          if (todaySpent <= staticActualDailyAllowance) {
            limitState = DashboardLimitState.overFirstLimit;
            firstMetric = DashboardMetric(
              name: 'Sisa Hari Ini',
              value: limit - todaySpent,
              type: MetricType.currency,
            );
          } else {
            limitState = DashboardLimitState.overLastLimit;
            firstMetric = DashboardMetric(
              name: 'Over Budget!',
              value: 0,
              type: MetricType.blocked,
            );
          }
        }

        break;
      case BudgetHealthScenario.moderate:
        limit = staticActualDailyAllowance;
        limitName = 'Batas harian aktual';
        secondMetric = DashboardMetric(
          name: 'Jatah Besok',
          value: tomorrowLimitPrediction,
          type: MetricType.currency,
        );

        if (todaySpent <= staticActualDailyAllowance) {
          firstMetric = DashboardMetric(
            name: 'Sisa Jatah Hari Ini',
            value: limit - todaySpent,
            type: MetricType.currency,
          );
        }

        if (todaySpent > staticActualDailyAllowance / 2 &&
            todaySpent <= staticActualDailyAllowance) {
          limitState = DashboardLimitState.overFirstLimit;
        } else if (todaySpent > staticActualDailyAllowance) {
          limitState = DashboardLimitState.overLastLimit;
          firstMetric = DashboardMetric(
            name: 'Over Budget!',
            value: 0,
            type: MetricType.blocked,
          );
        }

        break;
      case BudgetHealthScenario.critical:
        final maxSurvivalLimit = min(startOfDaySafeBalance, safetyFlooring);

        secondMetric = DashboardMetric(
          name: 'Uang Cukup Untuk',
          value: maxSurvivalLimit > 0
              ? max(safeBalance ~/ maxSurvivalLimit, 0)
              : 0,
          type: MetricType.day,
        );

        if (todaySpent <= staticActualDailyAllowance) {
          limit = staticActualDailyAllowance;
          limitName = 'Batas hemat ekstrem';
          limitState = DashboardLimitState.underFirstLimit;
          firstMetric = DashboardMetric(
            name: 'Sisa Jatah Ekstrem',
            value: limit - todaySpent,
            type: MetricType.currency,
          );
        } else if (todaySpent <= maxSurvivalLimit) {
          limit = maxSurvivalLimit;
          limitName = 'Batas bertahan hidup';
          limitState = DashboardLimitState.overFirstLimit;
          firstMetric = DashboardMetric(
            name: 'Sisa Jatah Survival',
            value: limit - todaySpent,
            type: MetricType.currency,
          );
        } else {
          limit = maxSurvivalLimit;
          limitName = 'Batas bertahan hidup';
          limitState = DashboardLimitState.overLastLimit;
          firstMetric = DashboardMetric(
            name: 'Over Budget!',
            value: 0,
            type: MetricType.blocked,
          );
        }
        break;
      case BudgetHealthScenario.deficit:
        final startOfDayBalance = balance + todaySpent;
        limit = min(startOfDayBalance, safetyFlooring);
        limitName = 'Batas harian maksimal';

        secondMetric = DashboardMetric(
          name: 'Total Defisit',
          value: max(totalUnpaidFixedCost - balance, 0),
          type: MetricType.currency,
        );

        if (limit == 0) {
          if (todaySpent > 0) {
            limitState = DashboardLimitState.overLastLimit;
            firstMetric = DashboardMetric(
              name: 'Over Budget!',
              value: 0,
              type: MetricType.blocked,
            );
          } else {
            limitState = DashboardLimitState.underFirstLimit;
            firstMetric = DashboardMetric(
              name: 'Sisa Jatah Maksimal',
              value: 0,
              type: MetricType.currency,
            );
          }
        } else {
          if (todaySpent <= limit) {
            limitState = DashboardLimitState.overFirstLimit;
            firstMetric = DashboardMetric(
              name: 'Sisa Jatah Maksimal',
              value: limit - todaySpent,
              type: MetricType.currency,
            );
          } else {
            limitState = DashboardLimitState.overLastLimit;
            firstMetric = DashboardMetric(
              name: 'Over Budget!',
              value: 0,
              type: MetricType.blocked,
            );
          }
        }
        break;
    }

    return DashboardMetricsResult(
      budgetCycle: budgetSnapshot.budgetCycle,
      balance: balance,
      safeBalance: safeBalance,
      todaySpent: todaySpent,
      limit: limit,
      limitName: limitName,
      totalUnpaidFixedCost: totalUnpaidFixedCost,
      remainingDaysInCycle: remainingDaysInCycle,
      unpaidFixedCosts: unpaidFixedCosts,
      firstMetric: firstMetric,
      secondMetric: secondMetric,
      healthScenario: scenario,
      limitState: limitState,
    );
  }

  BudgetHealthScenario _resolveScenario({
    required int actualDailyBudget,
    required int totalUnpaidFixedCost,
    required int safetyCeiling,
    required int safetyFlooring,
  }) {
    if (actualDailyBudget <= 0 && totalUnpaidFixedCost > 0) {
      return BudgetHealthScenario.deficit;
    }

    if (actualDailyBudget < safetyFlooring) {
      return BudgetHealthScenario.critical;
    }

    if (actualDailyBudget > safetyCeiling) {
      return BudgetHealthScenario.surplus;
    }

    return BudgetHealthScenario.moderate;
  }

  int _calculateTotalUnpaidFixedCost(
    List<UnpaidFixedCostEntity> unpaidFixedCosts,
  ) {
    final totalUnpaidFixedCost = unpaidFixedCosts.fold(
      0,
      (sum, item) => sum + (item.amount),
    );

    return totalUnpaidFixedCost;
  }

  int _remainingDaysInMonth(DateTime date) {
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0).day;
    return lastDayOfMonth - date.day + 1;
  }

  int _remainingDaysInWeek(DateTime date) {
    final daysUntilEndOfWeek = DateTime.daysPerWeek - date.weekday;
    return daysUntilEndOfWeek + 1;
  }
}

enum DashboardLimitState { underFirstLimit, overFirstLimit, overLastLimit }

enum MetricType { currency, day, blocked }

class DashboardMetric {
  final String name;
  final int value;
  final MetricType type;

  DashboardMetric({
    required this.name,
    required this.value,
    required this.type,
  });
}

class DashboardMetricsResult {
  final FinancialCycle budgetCycle;
  final int balance;
  final int safeBalance;
  final int todaySpent;
  final int limit;
  final String limitName;
  final int remainingDaysInCycle;
  final int totalUnpaidFixedCost;
  final List<UnpaidFixedCostEntity> unpaidFixedCosts;
  final DashboardMetric firstMetric;
  final DashboardMetric secondMetric;
  final BudgetHealthScenario healthScenario;
  final DashboardLimitState limitState;

  DashboardMetricsResult({
    required this.budgetCycle,
    required this.balance,
    required this.safeBalance,
    required this.todaySpent,
    required this.limit,
    required this.limitName,
    required this.totalUnpaidFixedCost,
    required this.remainingDaysInCycle,
    required this.unpaidFixedCosts,
    required this.firstMetric,
    required this.secondMetric,
    required this.healthScenario,
    required this.limitState,
  });
}
