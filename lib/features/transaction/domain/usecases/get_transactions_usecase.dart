import 'package:money_management_mobile/core/domain/entities/paginated_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_history_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';

class GetTransactionsUsecase {
  final TransactionRepository repository;

  GetTransactionsUsecase(this.repository);

  Future<PaginatedEntity<TransactionHistoryEntity>> execute() async {
    return await repository.getTransactions();
  }
}
