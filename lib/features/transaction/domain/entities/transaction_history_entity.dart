import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class TransactionHistoryEntity extends TransactionEntity {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionHistoryEntity({
    required super.name,
    required super.amount,
    required super.type,
    required super.categoryId,
    required super.transactionAt,
    super.note,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
}
