import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_entity.dart';

class FixedCostModel extends FixedCostEntity {
  const FixedCostModel({
    required super.name,
    required super.amount,
    required super.category,
    required super.categoryId,
    super.categoryType = CategoryType.system,
    super.isActive = true,
    required super.cycle,
    required super.dueValue,
  });

  factory FixedCostModel.fromEntity(FixedCostEntity entity) {
    return FixedCostModel(
      name: entity.name,
      amount: entity.amount,
      category: entity.category,
      categoryId: entity.categoryId,
      categoryType: entity.categoryType,
      isActive: entity.isActive,
      cycle: entity.cycle,
      dueValue: entity.dueValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'cycleType': cycle,
      'categoryId': categoryId,
      'categoryType': categoryType.value,
      'isActive': isActive,
      'dueDay': dueValue,
    };
  }
}
