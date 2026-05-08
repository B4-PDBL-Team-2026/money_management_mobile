import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_template_entity.dart';

class FixedCostTemplateModel extends FixedCostTemplateEntity {
  final int? id;

  const FixedCostTemplateModel({
    this.id,
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

  factory FixedCostTemplateModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final parsedId = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 0;

    final rawAmount = json['amount'];
    final amountStr = rawAmount?.toString() ?? '0';
    final amountInt = int.tryParse(amountStr.split('.').first) ?? 0;

    final rawCategory = json['category'];
    int parsedCategoryId = 0;
    String parsedCategoryName = '-';

    if (rawCategory is Map && rawCategory.containsKey('id')) {
      parsedCategoryId = rawCategory['id'] is int
          ? rawCategory['id']
          : int.tryParse(rawCategory['id']?.toString() ?? '') ?? 0;
      parsedCategoryName = rawCategory['name']?.toString() ?? '-';
    } else {
      // Some responses use categoryId/catgeory_id instead
      final rawCategoryId = json['categoryId'] ?? json['category_id'];
      parsedCategoryId = rawCategoryId is int
          ? rawCategoryId
          : int.tryParse(rawCategoryId?.toString() ?? '') ?? 0;
    }

    final rawCategoryType = json['categoryType'] ?? json['category_type'];
    final categoryType =
        (rawCategoryType is String &&
            rawCategoryType.toLowerCase().contains('custom'))
        ? CategoryType.custom
        : CategoryType.system;

    final rawCycle = json['cycleType'] ?? json['cycle_type'] ?? json['cycle'];
    final cycle = (rawCycle?.toString().toLowerCase() == 'weekly')
        ? FinancialCycle.weekly
        : FinancialCycle.monthly;

    final rawDue = json['dueDay'] ?? json['due_day'] ?? json['dueValue'];
    final parsedDue = rawDue is int
        ? rawDue
        : int.tryParse(rawDue?.toString() ?? '') ?? 1;

    final rawIsActive = json['isActive'] ?? json['is_active'];
    final isActive = rawIsActive is bool
        ? rawIsActive
        : (rawIsActive?.toString().toLowerCase() == 'true');

    return FixedCostTemplateModel(
      id: parsedId,
      name: json['name']?.toString() ?? '-',
      amount: amountInt,
      category: parsedCategoryName,
      categoryId: parsedCategoryId,
      categoryType: categoryType,
      isActive: isActive,
      cycle: cycle,
      dueValue: parsedDue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
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
