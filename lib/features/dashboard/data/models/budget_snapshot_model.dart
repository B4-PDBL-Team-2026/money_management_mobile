import 'package:money_management_mobile/features/dashboard/data/models/unpaid_fixed_cost_model.dart';
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

  factory BudgetSnapshotModel.fromJson(Map<String, dynamic> json) {
    return BudgetSnapshotModel(
      timestamp: DateTime.parse(json['server_time'] as String),
      balance: json['current_balance'] as int,
      budgetCycle: FinancialCycle.values.firstWhere(
        (e) => e.value == json['budget_cycle'] as String,
      ),
      safetyCeiling: json['safety_ceiling'] as int,
      safetyFlooring: json['safety_flooring'] as int,
      todaySpent: json['today_spent'] as int,
      todayLimit: json['today_limit'] as int,
      tomorrowLimitPrediction: json['tomorrow_limit_prediction'] as int,
      actualDailyAllowance: json['raw_today_limit'] as int,
      unpaidFixedCosts: (json['unpaid_fixed_costs'] as List<dynamic>)
          .map(
            (item) =>
                UnpaidFixedCostModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  BudgetSnapshotEntity toEntity() {
    return BudgetSnapshotEntity(
      timestamp: timestamp,
      balance: balance,
      budgetCycle: budgetCycle,
      safetyCeiling: safetyCeiling,
      safetyFlooring: safetyFlooring,
      todaySpent: todaySpent,
      todayLimit: todayLimit,
      tomorrowLimitPrediction: tomorrowLimitPrediction,
      actualDailyAllowance: actualDailyAllowance,
      unpaidFixedCosts: unpaidFixedCosts
          .whereType<UnpaidFixedCostModel>()
          .map((model) => model.toEntity())
          .toList(),
    );
  }
}
