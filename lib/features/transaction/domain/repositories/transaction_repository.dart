import 'package:money_management_mobile/core/domain/entities/paginated_entity.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_detail_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_history_entity.dart';

abstract class TransactionRepository {
  Future<TransactionEntity> addTransaction(TransactionEntity entity);
  Future<TransactionDetailEntity> getTransactionDetail({required int id});
  Future<void> updateTransaction({
    required int id,
    required String name,
    required int amount,
    required TransactionType type,
    required int categoryId,
    required RealCategoryType categoryType,
    required DateTime transactionDate,
    String? note,
  });
  Future<void> deleteTransaction({required int id});
  Future<PaginatedEntity<TransactionHistoryEntity>> getTransactions({
    int? page,
    String? search,
    int? categoryId,
    int? month,
    int? year,
  });
}
