import 'package:money_management_mobile/features/dashboard/domain/entities/budget_snapshot_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

class BudgetSnapshotModel extends BudgetSnapshotEntity {
  const BudgetSnapshotModel({
    required super.timestamp,
    required super.balance,
    required super.budgetCycle,
    required super.safetyCeiling,
    required super.safetyFlooring,
    required super.todaySpent,
    required super.todayLimit,
    required super.tomorrowLimitPrediction,
    required super.actualDailyAllowance,
    required super.unpaidFixedCosts,
  });
}

class UnpaidFixedCost {
  final String name;
  final int amount;
  final FinancialCycle cycle;
  final int dueValue;

  const UnpaidFixedCost({
    required this.name,
    required this.amount,
    required this.cycle,
    required this.dueValue,
  });
}
