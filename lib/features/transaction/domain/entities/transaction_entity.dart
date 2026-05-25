enum TransactionType {
  expense('expense'),
  income('income');

  final String value;

  const TransactionType(this.value);

  static TransactionType? fromValue(String? value) {
    if (value == null) {
      return null;
    }

    for (final transactionType in TransactionType.values) {
      if (transactionType.value == value) {
        return transactionType;
      }
    }

    return null;
  }
}

class TransactionEntity {
  final int? id;
  final String name;
  final int amount;
  final TransactionType type;
  final int categoryId;
  final String? note;
  final DateTime transactionAt;

  TransactionEntity({
    required this.name,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.transactionAt,
    this.note,
    this.id,
  });
}
