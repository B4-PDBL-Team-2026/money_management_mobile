import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/batch_transaction_detail_entity.dart';

class BatchTransactionDetailItemModel extends BatchTransactionDetailItemEntity {
  const BatchTransactionDetailItemModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.type,
    required super.source,
    super.note,
    required super.transactionAt,
    required super.categoryId,
    required super.categoryName,
    required super.categoryIcon,
  });

  factory BatchTransactionDetailItemModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'] is Map
        ? Map<String, dynamic>.from(json['category'] as Map)
        : <String, dynamic>{};

    final typeValue = json['type'] as String?;
    final type = typeValue == 'income'
        ? TransactionType.income
        : TransactionType.expense;

    final rawAmount = json['amount'];
    int parsedAmount = 0;
    if (rawAmount is int) {
      parsedAmount = rawAmount;
    } else if (rawAmount is double) {
      parsedAmount = rawAmount.toInt();
    } else if (rawAmount is String) {
      parsedAmount = double.tryParse(rawAmount)?.toInt() ?? 0;
    }

    final rawId = json['id'];
    final id = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 0;

    final rawCategoryId = category['id'];
    final categoryId = rawCategoryId is int
        ? rawCategoryId
        : int.tryParse(rawCategoryId?.toString() ?? '') ?? 0;

    final transactionAtRaw =
        (json['transactionAt'] as String?) ??
        (json['transaction_at'] as String?);
    final transactionAt =
        DateTime.tryParse(transactionAtRaw ?? '')?.toLocal() ?? DateTime.now();

    return BatchTransactionDetailItemModel(
      id: id,
      name: (json['name'] as String?) ?? '-',
      amount: parsedAmount,
      type: type,
      source: (json['source'] as String?) ?? 'manual',
      note: json['note'] as String?,
      transactionAt: transactionAt,
      categoryId: categoryId,
      categoryName: (category['name'] as String?) ?? '-',
      categoryIcon: (category['icon'] as String?) ?? 'question',
    );
  }

  BatchTransactionDetailItemEntity toEntity() {
    return BatchTransactionDetailItemEntity(
      id: id,
      name: name,
      amount: amount,
      type: type,
      source: source,
      note: note,
      transactionAt: transactionAt,
      categoryId: categoryId,
      categoryName: categoryName,
      categoryIcon: categoryIcon,
    );
  }
}

class BatchTransactionDetailModel extends BatchTransactionDetailEntity {
  const BatchTransactionDetailModel({
    required super.id,
    required super.name,
    super.note,
    required super.totalAmount,
    required super.transactionAt,
    required super.items,
  });

  factory BatchTransactionDetailModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final id = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 0;

    final rawTotalAmount = json['totalAmount'];
    int parsedTotalAmount = 0;
    if (rawTotalAmount is int) {
      parsedTotalAmount = rawTotalAmount;
    } else if (rawTotalAmount is double) {
      parsedTotalAmount = rawTotalAmount.toInt();
    } else if (rawTotalAmount is String) {
      parsedTotalAmount = double.tryParse(rawTotalAmount)?.toInt() ?? 0;
    }

    final transactionAtRaw =
        (json['transactionAt'] as String?) ??
        (json['transaction_at'] as String?);
    final transactionAt =
        DateTime.tryParse(transactionAtRaw ?? '')?.toLocal() ?? DateTime.now();

    final rawItems = json['items'] as List<dynamic>? ?? [];
    final items = rawItems
        .whereType<Map>()
        .map(
          (item) => BatchTransactionDetailItemModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList(growable: false);

    return BatchTransactionDetailModel(
      id: id,
      name: (json['name'] as String?) ?? '-',
      note: json['note'] as String?,
      totalAmount: parsedTotalAmount,
      transactionAt: transactionAt,
      items: items,
    );
  }

  BatchTransactionDetailEntity toEntity() {
    return BatchTransactionDetailEntity(
      id: id,
      name: name,
      note: note,
      totalAmount: totalAmount,
      transactionAt: transactionAt,
      items: items
          .whereType<BatchTransactionDetailItemModel>()
          .map((item) => item.toEntity())
          .toList(growable: false),
    );
  }
}
