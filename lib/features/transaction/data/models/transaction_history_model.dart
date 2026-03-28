import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_history_entity.dart';

class TransactionHistoryModel extends TransactionHistoryEntity {
  TransactionHistoryModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.type,
    required super.categoryId,
    required super.transactionDate,
    required super.createdAt,
    required super.updatedAt,
    super.note,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now().toUtc();

    return TransactionHistoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      amount: json['amount'] as int,
      type: json['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      categoryId: json['category_id'] as int,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : now,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : now,
      note: json['note'] as String?,
    );
  }
}
