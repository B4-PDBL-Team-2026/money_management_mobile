import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<TransactionEntity> addTransaction(TransactionEntity entity);
}
