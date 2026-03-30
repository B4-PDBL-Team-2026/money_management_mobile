enum FixedCostOccurrenceStatus {
  paid('paid'),
  pending('pending'),
  overdue('overdue'),
  skipped('skipped'),
  voided('void');

  final String value;

  const FixedCostOccurrenceStatus(this.value);

  static FixedCostOccurrenceStatus fromValue(String? rawValue) {
    if (rawValue == null || rawValue.trim().isEmpty) {
      return FixedCostOccurrenceStatus.pending;
    }

    return FixedCostOccurrenceStatus.values.firstWhere(
      (status) => status.value == rawValue,
      orElse: () => FixedCostOccurrenceStatus.pending,
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
  final FixedCostOccurrenceStatus status;

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
