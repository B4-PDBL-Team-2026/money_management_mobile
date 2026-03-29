import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';

class AddTransactionUseCase {
  final TransactionRepository repository;

  AddTransactionUseCase(this.repository);

  Future<TransactionEntity> execute({
    required String name,
    required int amount,
    required TransactionType type,
    required int categoryId,
    required DateTime transactionDate,
    String? note,
  }) {
    return repository.addTransaction(
      TransactionEntity(
        name: name,
        amount: amount,
        type: type,
        categoryId: categoryId,
        transactionDate: transactionDate,
        note: note,
      ),
    );
  }
}
