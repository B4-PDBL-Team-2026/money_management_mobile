import 'package:money_management_mobile/core/domain/entities/paginated_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_history_entity.dart';

abstract class TransactionRepository {
  Future<TransactionEntity> addTransaction(TransactionEntity entity);
  Future<PaginatedEntity<TransactionHistoryEntity>> getTransactions({
    int? page,
    String? search,
    int? categoryId,
    int? month,
    int? year,
  });
}
