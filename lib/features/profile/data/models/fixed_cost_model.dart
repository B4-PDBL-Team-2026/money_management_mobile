import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_entity.dart';

class FixedCostModel extends FixedCostEntity {
  const FixedCostModel({
    required super.name,
    required super.amount,
    required super.category,
    required super.cycle,
    required super.dueValue,
  });

  factory FixedCostModel.fromEntity(FixedCostEntity entity) {
    return FixedCostModel(
      name: entity.name,
      amount: entity.amount,
      category: entity.category,
      cycle: entity.cycle,
      dueValue: entity.dueValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'category': category,
      'cycle': cycle,
      'dueValue': dueValue,
    };
  }
}
