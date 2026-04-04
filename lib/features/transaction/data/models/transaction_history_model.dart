import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_history_entity.dart';

class TransactionHistoryModel extends TransactionHistoryEntity {
  TransactionHistoryModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.type,
    required super.categoryId,
    required super.transactionAt,
    required super.createdAt,
    required super.updatedAt,
    super.note,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now().toUtc();

    return TransactionHistoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      amount: double.parse(json['amount'] as String).toInt(),
      type: json['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      categoryId: json['category_id'] as int,
      transactionAt: DateTime.parse(json['transaction_at'] as String).toLocal(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : now,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : now,
      note: json['note'] as String?,
    );
  }

  TransactionHistoryEntity toEntity() {
    return TransactionHistoryEntity(
      id: id,
      name: name,
      amount: amount,
      type: type,
      categoryId: categoryId,
      transactionAt: transactionAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      note: note,
    );
  }
}
