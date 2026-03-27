import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/transaction/data/models/transaction_model.dart';

class TransactionRemoteDataSource {
  final Dio dio;
  final _log = Logger('TransactionRemoteDataSource');

  TransactionRemoteDataSource(this.dio);

  Future<TransactionModel> addTransaction(
    TransactionModel transactionModel,
  ) async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(seconds: 1));
      return transactionModel;
    }

    try {
      await dio.post('/transaction', data: transactionModel.toJson());
      return transactionModel;
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, ' Add Transaction');
    } catch (e) {
      _log.severe('Unexpected error while adding transaction', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat menambah transaksi',
      );
    }
  }
}
