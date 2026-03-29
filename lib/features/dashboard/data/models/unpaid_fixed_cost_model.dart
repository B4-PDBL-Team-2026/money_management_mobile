import 'package:money_management_mobile/features/dashboard/domain/entities/unpaid_fixed_cost_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

class UnpaidFixedCostModel extends UnpaidFixedCostEntity {
  const UnpaidFixedCostModel({
    required super.name,
    required super.amount,
    required super.cycle,
    required super.dueValue,
  });

  factory UnpaidFixedCostModel.fromJson(Map<String, dynamic> json) {
    return UnpaidFixedCostModel(
      name: json['name'] as String,
      amount: json['amount'] as int,
      cycle: FinancialCycle.values.firstWhere(
        (e) => e.value == json['cycle'] as String,
      ),
      dueValue: json['due_value'] as int,
    );
  }

  UnpaidFixedCostEntity toEntity() {
    return UnpaidFixedCostEntity(
      name: name,
      amount: amount,
      cycle: cycle,
      dueValue: dueValue,
    );
  }
}
