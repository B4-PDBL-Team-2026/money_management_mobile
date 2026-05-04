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

    int parseAmount(dynamic value) {
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      if (value is String) {
        final parsed = double.tryParse(value);
        if (parsed != null) {
          return parsed.toInt();
        }
      }
      return 0;
    }

    String? readString(dynamic value) {
      return value is String ? value : null;
    }

    DateTime? readDate(dynamic value) {
      final raw = readString(value);
      return raw != null ? DateTime.parse(raw) : null;
    }

    final category = json['category'];
    final categoryId =
        json['categoryId'] ??
        json['category_id'] ??
        (category is Map<String, dynamic> ? category['id'] : null);

    final transactionAt = json['transactionAt'] ?? json['transaction_at'];
    final createdAt = json['createdAt'] ?? json['created_at'];
    final updatedAt = json['updatedAt'] ?? json['updated_at'];

    return TransactionHistoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      amount: parseAmount(json['amount']),
      type: json['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      categoryId: (categoryId as num?)?.toInt() ?? 0,
      transactionAt: (readDate(transactionAt) ?? now).toLocal(),
      createdAt: readDate(createdAt) ?? now,
      updatedAt: readDate(updatedAt) ?? now,
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
