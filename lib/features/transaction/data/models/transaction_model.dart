import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.type,
    required super.categoryId,
    required super.transactionDate,
    super.note,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: json['amount'] as int,
      type: _transactionKindFromString(json['type'] as String),
      categoryId: json['categoryId'] as int,
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      name: entity.name,
      amount: entity.amount,
      type: entity.type,
      categoryId: entity.categoryId,
      transactionDate: entity.transactionDate,
      note: entity.note,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'type': type.name,
      'categoryId': categoryId,
      'transactionDate': transactionDate.toIso8601String(),
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static TransactionKind _transactionKindFromString(String value) {
    return TransactionKind.values.firstWhere(
      (kind) => kind.name == value,
      orElse: () => TransactionKind.expense,
    );
  }
}
