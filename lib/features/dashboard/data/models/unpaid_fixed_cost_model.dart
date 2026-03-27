import 'package:money_management_mobile/features/dashboard/domain/entities/unpaid_fixed_cost_entity.dart';

class UnpaidFixedCostModel extends UnpaidFixedCostEntity {
  const UnpaidFixedCostModel({
    required super.name,
    required super.amount,
    required super.cycle,
    required super.dueValue,
  });
}
