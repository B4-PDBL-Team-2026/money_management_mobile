import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

enum TransactionHistoryFeedType {
  batch('batch'),
  single('single');

  final String value;

  const TransactionHistoryFeedType(this.value);

  static TransactionHistoryFeedType? fromValue(String? value) {
    if (value == null) {
      return null;
    }

    for (final transactionHistoryFeedType
        in TransactionHistoryFeedType.values) {
      if (transactionHistoryFeedType.value == value) {
        return transactionHistoryFeedType;
      }
    }

    return null;
  }
}

enum TransactionSource {
  initialBalance('initial_balance'),
  manual('manual'),
  fixedCostPayment('fixed_cost_payment'),
  receiptScan('receipt_scan');

  final String value;

  const TransactionSource(this.value);

  static TransactionSource? fromValue(String? value) {
    if (value == null) {
      return null;
    }

    for (final TransactionSource in TransactionSource.values) {
      if (TransactionSource.value == value) {
        return TransactionSource;
      }
    }

    return null;
  }
}

class TransactionHistoryEntity {
  final int id;
  final String name;
  final int amount;
  final DateTime transactionAt;
  final TransactionSource? source;
  final TransactionHistoryFeedType? feedType;
  final TransactionType? type;
  final int? categoryId;
  final String? note;

  TransactionHistoryEntity({
    required this.name,
    required this.amount,
    required this.transactionAt,
    required this.id,
    this.feedType,
    this.source,
    this.categoryId,
    this.type,
    this.note,
  });
}
