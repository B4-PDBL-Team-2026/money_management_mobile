import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_history_entity.dart';

class AddBatchTransactionEntity {
  final String name;
  final DateTime transactionAt;
  final String? note;
  final TransactionSource source;
  final List<TransactionEntity> items;

  const AddBatchTransactionEntity({
    required this.name,
    required this.transactionAt,
    this.note,
    required this.source,
    required this.items,
  });
}
