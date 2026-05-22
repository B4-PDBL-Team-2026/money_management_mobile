import 'dart:io';

import 'package:money_management_mobile/core/domain/entities/paginated_entity.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/add_batch_transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/batch_transaction_detail_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_detail_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_history_entity.dart';

abstract class TransactionRepository {
  Future<TransactionEntity> addTransaction(TransactionEntity entity);
  Future<void> addBatchTransaction(AddBatchTransactionEntity entity);
  Future<void> updateBatchTransaction({
    required int id,
    required AddBatchTransactionEntity entity,
  });
  Future<TransactionDetailEntity> getTransactionDetail({required int id});
  Future<void> updateTransaction({
    required int id,
    required String name,
    required int amount,
    required TransactionType type,
    required int categoryId,
    required DateTime transactionAt,
    String? note,
  });
  Future<void> deleteTransaction({required int id});
  Future<void> deleteBatchTransaction({required int id});
  Future<PaginatedEntity<TransactionHistoryEntity>> getTransactions({
    int? page,
    String? search,
    int? categoryId,
    int? month,
    int? year,
  });
  Future<BatchTransactionDetailEntity> getBatchTransactionDetail({
    required int id,
  });
  Future<AddBatchTransactionEntity> parseReceiptImage(
    File image, {
    required List<CategoryEntity> categories,
  });
}
