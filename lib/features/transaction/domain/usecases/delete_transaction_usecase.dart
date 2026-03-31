import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';

class DeleteTransactionUseCase {
  final TransactionRepository repository;

  DeleteTransactionUseCase(this.repository);

  Future<void> execute({required int id}) {
    return repository.deleteTransaction(id: id);
  }
}
