enum TransactionKind { expense, income }

class TransactionEntity {
  final String id;
  final String name;
  final int amount;
  final TransactionKind type;
  final int categoryId;
  final DateTime transactionDate;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.transactionDate,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });
}
