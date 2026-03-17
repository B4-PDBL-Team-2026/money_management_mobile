import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/transaction/data/data_sources/remote/transaction_remote_data_source.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final _log = Logger('TransactionRepository');

  TransactionRepositoryImpl(this.remoteDataSource);

  @override
  Future<TransactionEntity> addTransaction({
    required String name,
    required int amount,
    required TransactionKind type,
    required int categoryId,
    required DateTime transactionDate,
    String? note,
  }) async {
    _log.info('Adding transaction: $name');

    try {
      final model = await remoteDataSource.addTransaction(
        name: name,
        amount: amount,
        type: type,
        categoryId: categoryId,
        transactionDate: transactionDate,
        note: note,
      );

      _log.info('Add transaction successful: ${model.id}');
      return model;
    } on DioException catch (e) {
      ErrorHandler.handleRemoteException(e, _log, 'Add transaction');
      rethrow;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      _log.severe('Unexpected add transaction error', e);
      throw UnexpectedException(e.toString());
    }
  }
}
