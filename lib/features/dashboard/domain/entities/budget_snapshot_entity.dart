import 'package:money_management_mobile/features/dashboard/domain/entities/unpaid_fixed_cost_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

class BudgetSnapshotEntity {
  final DateTime timestamp;
  final int balance;
  final FinancialCycle budgetCycle;
  final int safetyCeiling;
  final int safetyFlooring;
  final int todaySpent;
  final int todayLimit;
  final int tomorrowLimitPrediction;
  final int actualDailyAllowance;
  final List<UnpaidFixedCostEntity> unpaidFixedCosts;

  const BudgetSnapshotEntity({
    required this.timestamp,
    required this.balance,
    required this.budgetCycle,
    required this.safetyCeiling,
    required this.safetyFlooring,
    required this.todaySpent,
    required this.todayLimit,
    required this.tomorrowLimitPrediction,
    required this.actualDailyAllowance,
    required this.unpaidFixedCosts,
  });
}
