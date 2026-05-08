import 'package:money_management_mobile/features/transaction/domain/entities/transaction_detail_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class TransactionDetailModel extends TransactionDetailEntity {
  TransactionDetailModel({
    required super.id,
    required super.categoryId,
    required super.categoryName,
    super.categoryIcon,
    required super.type,
    required super.source,
    required super.name,
    required super.amount,
    required super.transactionAt,
    required super.note,
  });

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'] is Map
        ? Map<String, dynamic>.from(json['category'] as Map)
        : <String, dynamic>{};
    final typeValue = json['type'] as String?;

    return TransactionDetailModel(
      id: _parseInt(json['id']),
      categoryId: _parseInt(category['id']),
      categoryName: category['name'] as String? ?? '-',
      categoryIcon: category['icon'] as String?,
      type: _parseTransactionType(typeValue),
      source: (json['source'] as String?) ?? '-',
      name: (json['name'] as String?) ?? '-',
      amount: _parseAmount(json['amount']),
      transactionAt:
          DateTime.tryParse(
            (json['transactionAt'] as String?) ??
                (json['transaction_at'] as String?) ??
                '',
          )?.toLocal() ??
          DateTime.now(),
      note: json['note'] as String?,
    );
  }

  TransactionDetailEntity toEntity() {
    return TransactionDetailEntity(
      id: id,
      categoryId: categoryId,
      categoryName: categoryName,
      categoryIcon: categoryIcon,
      type: type,
      source: source,
      name: name,
      amount: amount,
      transactionAt: transactionAt,
      note: note,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _parseAmount(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    if (value is String) {
      return double.tryParse(value)?.toInt() ?? 0;
    }

    return 0;
  }

  static TransactionType? _parseTransactionType(String? value) {
    if (value == TransactionType.expense.value) {
      return TransactionType.expense;
    }

    if (value == TransactionType.income.value) {
      return TransactionType.income;
    }

    return null;
  }
}
