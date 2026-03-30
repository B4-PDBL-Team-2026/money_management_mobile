import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_occurrence_entity.dart';

class FixedCostOccurrenceModel extends FixedCostOccurrenceEntity {
  const FixedCostOccurrenceModel({
    required super.id,
    required super.fixedCostTemplateId,
    required super.name,
    required super.amountRaw,
    required super.categoryId,
    required super.cycleType,
    required super.dueDate,
    required super.status,
  });

  factory FixedCostOccurrenceModel.fromJson(Map<String, dynamic> json) {
    final rawCycleType = json['cycle_type'] as String?;
    final fallbackCycleKey = json['cycle_key'] as String?;
    final rawId = json['id'];
    final rawTemplateId = json['fixed_cost_template_id'];
    final rawCategoryId = json['category_id'];

    final parsedOccurrenceId = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 0;
    final parsedTemplateId = rawTemplateId is int
        ? rawTemplateId
        : int.tryParse(rawTemplateId?.toString() ?? '') ?? parsedOccurrenceId;

    return FixedCostOccurrenceModel(
      id: parsedOccurrenceId,
      fixedCostTemplateId: parsedTemplateId,
      name: json['name'] as String? ?? '-',
      amountRaw: json['amount'] as String? ?? '0',
      categoryId: rawCategoryId is int
          ? rawCategoryId
          : int.tryParse(rawCategoryId?.toString() ?? '') ?? 0,
      cycleType: rawCycleType ?? fallbackCycleKey ?? '-',
      dueDate:
          DateTime.tryParse(json['due_date'] as String? ?? '') ??
          DateTime.now(),
      status: FixedCostOccurrenceStatus.fromValue(json['status'] as String?),
    );
  }

  FixedCostOccurrenceEntity toEntity() {
    return FixedCostOccurrenceEntity(
      id: id,
      fixedCostTemplateId: fixedCostTemplateId,
      name: name,
      amountRaw: amountRaw,
      categoryId: categoryId,
      cycleType: cycleType,
      dueDate: dueDate,
      status: status,
    );
  }
}
