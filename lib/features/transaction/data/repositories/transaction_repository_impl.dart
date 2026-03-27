import 'package:money_management_mobile/features/transaction/data/data_sources/remote/transaction_remote_data_source.dart';
import 'package:money_management_mobile/features/transaction/data/models/transaction_model.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl(this.remoteDataSource);

  @override
  Future<TransactionEntity> addTransaction(TransactionEntity entity) async {
    final transactionModel = await remoteDataSource.addTransaction(
      TransactionModel.fromEntity(entity),
    );
    return transactionModel;
  }
}
