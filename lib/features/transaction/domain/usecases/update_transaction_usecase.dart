import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';

class UpdateTransactionUseCase {
  final TransactionRepository repository;

  UpdateTransactionUseCase(this.repository);

  Future<void> execute({
    required int id,
    required String name,
    required int amount,
    required TransactionType type,
    required int categoryId,
    required DateTime transactionDate,
    String? note,
  }) {
    return repository.updateTransaction(
      id: id,
      name: name,
      amount: amount,
      type: type,
      categoryId: categoryId,
      transactionDate: transactionDate,
      note: note,
    );
  }
}
