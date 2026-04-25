import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.name,
    required super.amount,
    required super.type,
    required super.categoryId,
    required super.transactionAt,
    super.note,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      name: json['name'] as String,
      amount: json['amount'] as int,
      type: json['type'] as String == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      categoryId: json['categoryId'] as int,
      transactionAt: TimezoneConverter.toLocal(
        json['transaction_at'] as String,
      ),
      note: json['note'] as String?,
    );
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      name: entity.name,
      amount: entity.amount,
      type: entity.type,
      categoryId: entity.categoryId,
      transactionAt: entity.transactionAt,
      note: entity.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'type': type.value,
      'categoryId': categoryId,
      'transactionAt': TimezoneConverter.toUtcString(transactionAt),
      'note': note,
    };
  }
}
