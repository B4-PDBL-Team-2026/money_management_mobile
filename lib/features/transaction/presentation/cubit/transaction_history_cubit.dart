import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/usecases/get_transactions_usecase.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_history_state.dart';

@LazySingleton()
class TransactionHistoryCubit extends Cubit<TransactionHistoryState> {
  final GetTransactionsUsecase getTransactionsUsecase;
  final _log = Logger('TransactionHistoryCubit');

  TransactionHistoryCubit(this.getTransactionsUsecase)
    : super(TransactionHistoryInitial());

  Future<void> getFreshTransactionHistory({
    String? search,
    CategoryEntity? categoryEntity,
    int? month,
    int? year,
  }) async {
    emit(TransactionHistoryLoading());

    try {
      final result = await getTransactionsUsecase.execute(
        search: search,
        categoryEntity: categoryEntity,
        month: month,
        year: year,
      );

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

  Future<void> loadMoreTransactionHistory({
    String? search,
    CategoryEntity? categoryEntity,
    int? month,
    int? year,
    required int page,
  }) async {
    if (state is TransactionHistorySuccess) {
      final currentState = state as TransactionHistorySuccess;

      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final result = await getTransactionsUsecase.execute(
          search: search,
          categoryEntity: categoryEntity,
          month: month,
          year: year,
          page: page,
        );

        final transactionHistory = result.items;
        final totalItems = result.totalItems;
        final totalPages = result.totalPages;
        final currentPage = result.currentPage;

        emit(
          TransactionHistorySuccess(
            [...currentState.transactionHistory, ...transactionHistory],
            currentPage,
            totalPages,
            totalItems,
            isLoadingMore: false,
          ),
        );
      } on NetworkException catch (e) {
        _log.severe('Error fetching more transaction history', e);
        emit(TransactionHistoryError(e.message));
      } on UnexpectedException catch (e) {
        _log.severe('Error fetching more transaction history', e);
        emit(TransactionHistoryError(e.message));
      } catch (e) {
        _log.severe('Error fetching more transaction history', e);
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
}
