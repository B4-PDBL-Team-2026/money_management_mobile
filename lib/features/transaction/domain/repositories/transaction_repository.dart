import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<TransactionEntity> addTransaction({
    required String name,
    required int amount,
    required TransactionKind type,
    required int categoryId,
    required DateTime transactionDate,
    String? note,
  });
}
