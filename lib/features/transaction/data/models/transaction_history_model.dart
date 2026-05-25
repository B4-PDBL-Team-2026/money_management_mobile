import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_history_entity.dart';

class TransactionHistoryModel extends TransactionHistoryEntity {
  TransactionHistoryModel({
    required super.name,
    required super.amount,
    required super.transactionAt,
    required super.id,
    super.feedType,
    super.source,
    super.categoryId,
    super.type,
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

    return TransactionHistoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      amount: parseAmount(json['amount']),
      type: TransactionType.fromValue(json['type']),
      categoryId: (categoryId as num?)?.toInt(),
      transactionAt: (readDate(transactionAt) ?? now).toLocal(),
      note: json['note'] as String?,
      feedType: TransactionHistoryFeedType.fromValue(json['feedType']),
      source: TransactionSource.fromValue(json['source']),
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
      note: note,
      feedType: feedType,
      source: source,
    );
  }
}
