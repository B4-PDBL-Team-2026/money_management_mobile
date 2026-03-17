import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/transaction/data/models/transaction_model.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class TransactionRemoteDataSource {
  final Dio dio;
  final _log = Logger('TransactionRemoteDataSource');

  TransactionRemoteDataSource(this.dio);

  Future<TransactionModel> addTransaction({
    required String name,
    required int amount,
    required TransactionKind type,
    required int categoryId,
    required DateTime transactionDate,
    String? note,
  }) async {
    _log.fine('Submitting add transaction request');
    _log.fine(
      'Request payload: {name: $name, amount: $amount, type: ${type.name}, note: $note, transactionDate: ${transactionDate.toIso8601String()}, categoryId: $categoryId}',
    );

    // Dummy integration setup while API is not connected yet.
    await Future.delayed(const Duration(seconds: 1));

    if (name.toLowerCase() == 'error') {
      _log.warning('Dummy add transaction failed due to simulated condition');
      throw ServerException('Simulasi gagal menyimpan transaksi');
    }

    final now = DateTime.now().toUtc();
    final model = TransactionModel(
      id: now.millisecondsSinceEpoch.toString(),
      name: name,
      amount: amount,
      type: type,
      categoryId: categoryId,
      transactionDate: transactionDate,
      note: note,
      createdAt: now,
      updatedAt: now,
    );

    _log.info('Dummy add transaction success with id: ${model.id}');
    return model;
  }
}
