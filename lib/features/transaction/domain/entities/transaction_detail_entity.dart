import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class TransactionDetailEntity {
  final int id;
  final int userId;
  final String categoryType;
  final int categoryId;
  final int? fixedCostOccurrenceId;
  final TransactionType? type;
  final String source;
  final String name;
  final int amount;
  final DateTime transactionDate;
  final DateTime? effectiveAt;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  TransactionDetailEntity({
    required this.id,
    required this.userId,
    required this.categoryType,
    required this.categoryId,
    required this.fixedCostOccurrenceId,
    required this.type,
    required this.source,
    required this.name,
    required this.amount,
    required this.transactionDate,
    required this.effectiveAt,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
}
