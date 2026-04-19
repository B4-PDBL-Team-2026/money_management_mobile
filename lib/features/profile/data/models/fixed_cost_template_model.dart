import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_template_entity.dart';

class FixedCostTemplateModel extends FixedCostTemplateEntity {
  const FixedCostTemplateModel({
    required super.name,
    required super.amount,
    required super.category,
    required super.categoryId,
    super.categoryType = CategoryType.system,
    super.isActive = true,
    required super.cycle,
    required super.dueValue,
  });

  factory FixedCostTemplateModel.fromEntity(FixedCostTemplateEntity entity) {
    return FixedCostTemplateModel(
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
      'cycleType': cycle.value,
      'categoryId': categoryId,
      'categoryType': categoryType.value,
      'isActive': isActive,
      'dueDay': dueValue,
    };
  }
}
