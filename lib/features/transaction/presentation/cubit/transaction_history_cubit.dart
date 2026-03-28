import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/transaction/domain/usecases/get_transactions_usecase.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_history_state.dart';

class TransactionHistoryCubit extends Cubit<TransactionHistoryState> {
  final GetTransactionsUsecase getTransactionsUsecase;
  final _log = Logger('TransactionHistoryCubit');

  TransactionHistoryCubit(this.getTransactionsUsecase)
    : super(TransactionHistoryInitial());

  Future<void> getTransactionHistory() async {
    emit(TransactionHistoryLoading());

    try {
      final result = await getTransactionsUsecase.execute();
      final transactionHistory = result.items;
      final totalItems = result.totalItems;
      final totalPages = result.totalPages;
      final currentPage = result.currentPage;

      emit(
        TransactionHistorySuccess(
          transactionHistory,
          currentPage,
          totalPages,
          totalItems,
        ),
      );
    } on NetworkException catch (e) {
      _log.severe('Error fetching transaction history', e);
      emit(TransactionHistoryError(e.message));
    } on UnexpectedException catch (e) {
      _log.severe('Error fetching transaction history', e);
      emit(TransactionHistoryError(e.message));
    } catch (e) {
      _log.severe('Error fetching transaction history', e);
      if (kDebugMode) {
        emit(TransactionHistoryError('Terjadi kesalahan: ${e.toString()}'));
      } else {
        emit(
          TransactionHistoryError(
            'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
    }
  }
}
