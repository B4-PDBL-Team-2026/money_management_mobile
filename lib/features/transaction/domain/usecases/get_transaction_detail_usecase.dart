import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_detail_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';

@Injectable()
class GetTransactionDetailUseCase {
  final TransactionRepository repository;

  GetTransactionDetailUseCase(this.repository);

  Future<TransactionDetailEntity> execute({required int id}) {
    return repository.getTransactionDetail(id: id);
  }
}
