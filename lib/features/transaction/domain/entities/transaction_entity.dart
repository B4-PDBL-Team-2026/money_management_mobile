enum TransactionType {
  expense('expense'),
  income('income');

  final String value;

  const TransactionType(this.value);
}

class TransactionEntity {
  final String name;
  final int amount;
  final TransactionType type;
  final int categoryId;
  final String? note;
  final DateTime transactionDate;

  TransactionEntity({
    required this.name,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.transactionDate,
    this.note,
  });
}
