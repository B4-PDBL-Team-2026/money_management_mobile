import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class BatchTransactionDetailItemEntity {
  final int id;
  final String name;
  final int amount;
  final TransactionType type;
  final String source;
  final String? note;
  final DateTime transactionAt;
  final int categoryId;
  final String categoryName;
  final String categoryIcon;

  const BatchTransactionDetailItemEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.type,
    required this.source,
    this.note,
    required this.transactionAt,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
  });
}

class BatchTransactionDetailEntity {
  final int id;
  final String name;
  final String? note;
  final int totalAmount;
  final DateTime transactionAt;
  final List<BatchTransactionDetailItemEntity> items;

  const BatchTransactionDetailEntity({
    required this.id,
    required this.name,
    this.note,
    required this.totalAmount,
    required this.transactionAt,
    required this.items,
  });
}
