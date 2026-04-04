import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.name,
    required super.amount,
    required super.type,
    required super.categoryId,
    required super.transactionDate,
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
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      note: json['note'] as String?,
    );
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      name: entity.name,
      amount: entity.amount,
      type: entity.type,
      categoryId: entity.categoryId,
      transactionDate: entity.transactionDate,
      note: entity.note,
    );
  }

  Map<String, dynamic> toJson() {
    // final transactionMonth = transactionDate.month < 10
    //     ? '0${transactionDate.month}'
    //     : transactionDate.month;

    return {
      'name': name,
      'amount': amount,
      'type': type.value,
      'categoryId': categoryId,
      // TODO: sudah diformat UTC secara paksa di cubit, pakai lagi setelah difix!
      'transactionDate': transactionDate/* .toUtc() */.toIso8601String(),
      'note': note,
      // TODO: hardcode categoryType karena API butuh, tapi seharusnya bisa diambil dari categoryId
      // ganti dengan entity menyimpan category langsung, bukan id
      'categoryType': RealCategoryType.system.value,
    };
  }
}
