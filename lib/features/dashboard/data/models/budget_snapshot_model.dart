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

  factory BudgetSnapshotModel.fromJson(
    Map<String, dynamic> json, {
    List<UnpaidFixedCostModel>? unpaidFixedCosts,
  }) {
    return BudgetSnapshotModel(
      timestamp: DateTime.parse(json['serverTime'] as String),
      balance: json['currentBalance'] as int,
      budgetCycle: FinancialCycle.values.firstWhere(
        (e) => e.value == json['budgetCycle'] as String,
      ),
      safetyCeiling: json['safetyCeiling'] as int,
      safetyFlooring: json['safetyFlooring'] as int,
      todaySpent: json['todaySpent'] as int,
      todayLimit: json['todayLimit'] as int,
      tomorrowLimitPrediction: json['tomorrowLimitPrediction'] as int,
      actualDailyAllowance: json['rawTodayLimit'] as int,
      unpaidFixedCosts:
          unpaidFixedCosts ??
          (json['unpaidFixedCosts'] as List<dynamic>)
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
