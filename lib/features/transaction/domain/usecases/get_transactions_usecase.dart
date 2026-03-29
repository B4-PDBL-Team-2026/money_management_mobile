import 'package:money_management_mobile/core/domain/entities/paginated_entity.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_history_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';

class GetTransactionsUsecase {
  final TransactionRepository repository;

  GetTransactionsUsecase(this.repository);

  Future<PaginatedEntity<TransactionHistoryEntity>> execute({
    int? page = 1,
    String? search,
    CategoryEntity? categoryEntity,
    int? month,
    int? year,
  }) async {
    return await repository.getTransactions(
      page: page,
      search: search,
      categoryId: categoryEntity?.id,
      month: month,
      year: year,
    );
  }
}
