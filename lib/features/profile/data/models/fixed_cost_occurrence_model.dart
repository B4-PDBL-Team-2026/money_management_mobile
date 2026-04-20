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
    final rawTemplateId = json['fixed_cost_template_id'] ?? json['id'];
    final rawCategoryId = json['category_id'];
    final rawDueDay = json['due_day'] ?? json['due_value'];

    final parsedOccurrenceId = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 0;
    final parsedTemplateId = rawTemplateId is int
        ? rawTemplateId
        : int.tryParse(rawTemplateId?.toString() ?? '') ?? parsedOccurrenceId;
    final parsedDueDay = rawDueDay is int
        ? rawDueDay
        : int.tryParse(rawDueDay?.toString() ?? '');
    final cycleType = (rawCycleType ?? fallbackCycleKey ?? '-').toLowerCase();

    return FixedCostOccurrenceModel(
      id: parsedOccurrenceId,
      fixedCostTemplateId: parsedTemplateId,
      name: json['name'] as String? ?? '-',
      amountRaw: json['amount'] as String? ?? '0',
      categoryId: rawCategoryId is int
          ? rawCategoryId
          : int.tryParse(rawCategoryId?.toString() ?? '') ?? 0,
      cycleType: rawCycleType ?? fallbackCycleKey ?? '-',
      dueDate: _resolveDueDate(
        dueDateRaw: json['due_date'] as String?,
        cycleType: cycleType,
        dueDay: parsedDueDay,
      ),
      status: FixedCostOccurenceStatus.fromValue(json['status'] as String?),
    );
  }

  static DateTime _resolveDueDate({
    required String? dueDateRaw,
    required String cycleType,
    required int? dueDay,
  }) {
    final parsedDueDate = DateTime.tryParse(dueDateRaw ?? '');
    if (parsedDueDate != null) {
      return parsedDueDate;
    }

    final safeDueDay = dueDay ?? 1;

    if (cycleType == 'weekly') {
      final normalizedWeekday = safeDueDay.clamp(1, 7);
      final mondayReference = DateTime(2024, 1, 1);
      return mondayReference.add(Duration(days: normalizedWeekday - 1));
    }

    final now = DateTime.now();
    final lastDayInMonth = DateTime(now.year, now.month + 1, 0).day;
    final normalizedDay = safeDueDay.clamp(1, lastDayInMonth);
    return DateTime(now.year, now.month, normalizedDay);
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
