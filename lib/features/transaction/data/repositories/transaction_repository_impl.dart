import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/core/domain/entities/paginated_entity.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/data/data_sources/remote/transaction_remote_data_source.dart';
import 'package:money_management_mobile/features/transaction/data/models/transaction_model.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_detail_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_history_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';

@LazySingleton(as: TransactionRepository)
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

  @override
  Future<TransactionDetailEntity> getTransactionDetail({
    required int id,
  }) async {
    final model = await remoteDataSource.getTransactionDetail(id: id);
    return model.toEntity();
  }

  @override
  Future<void> updateTransaction({
    required int id,
    required String name,
    required int amount,
    required TransactionType type,
    required int categoryId,
    required RealCategoryType categoryType,
    required DateTime transactionDate,
    String? note,
  }) async {
    await remoteDataSource.updateTransaction(
      id: id,
      name: name,
      amount: amount,
      type: type,
      categoryId: categoryId,
      categoryType: categoryType,
      transactionDate: transactionDate,
      note: note,
    );
  }

  @override
  Future<void> deleteTransaction({required int id}) async {
    await remoteDataSource.deleteTransaction(id: id);
  }

  @override
  Future<PaginatedEntity<TransactionHistoryEntity>> getTransactions({
    int? page,
    String? search,
    int? categoryId,
    int? month,
    int? year,
  }) async {
    final model = await remoteDataSource.getTransaction(
      page: page,
      search: search,
      categoryId: categoryId,
      month: month,
      year: year,
    );

    return model.toEntity((item) => item.toEntity());
  }
}
