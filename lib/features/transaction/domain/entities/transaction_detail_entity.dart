import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class TransactionDetailEntity {
  final int id;
  final int categoryId;
  final String categoryName;
  final String? categoryIcon;
  final TransactionType? type;
  final String source;
  final String name;
  final int amount;
  final DateTime transactionAt;
  final String? note;

  TransactionDetailEntity({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    this.categoryIcon,
    required this.type,
    required this.source,
    required this.name,
    required this.amount,
    required this.transactionAt,
    required this.note,
  });
}
