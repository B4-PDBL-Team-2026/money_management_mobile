import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

enum BatchTransactionSource {
  initialBalance('initial_balance'),
  manual('manual'),
  fixedCostPayment('fixed_cost_payment'),
  receiptScan('receipt_scan');

  final String value;

  const BatchTransactionSource(this.value);
}

class AddBatchTransactionEntity {
  final String name;
  final DateTime transactionAt;
  final String? note;
  final BatchTransactionSource source;
  final List<TransactionEntity> items;

  const AddBatchTransactionEntity({
    required this.name,
    required this.transactionAt,
    this.note,
    required this.source,
    required this.items,
  });
}
