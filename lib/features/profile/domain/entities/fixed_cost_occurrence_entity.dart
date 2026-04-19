enum FixedCostOccurenceStatus {
  paid('paid'),
  pending('pending'),
  overdue('overdue'),
  skipped('skipped'),
  voided('void');

  final String value;

  const FixedCostOccurenceStatus(this.value);

  static FixedCostOccurenceStatus fromValue(String? rawValue) {
    if (rawValue == null || rawValue.trim().isEmpty) {
      return FixedCostOccurenceStatus.pending;
    }

    return FixedCostOccurenceStatus.values.firstWhere(
      (status) => status.value == rawValue,
      orElse: () => FixedCostOccurenceStatus.pending,
    );
  }
}

class FixedCostOccurrenceEntity {
  final int id;
  final int fixedCostTemplateId;
  final String name;
  final String amountRaw;
  final int categoryId;
  final String cycleType;
  final DateTime dueDate;
  final FixedCostOccurenceStatus status;

  const FixedCostOccurrenceEntity({
    required this.id,
    required this.fixedCostTemplateId,
    required this.name,
    required this.amountRaw,
    required this.categoryId,
    required this.cycleType,
    required this.dueDate,
    required this.status,
  });
}
