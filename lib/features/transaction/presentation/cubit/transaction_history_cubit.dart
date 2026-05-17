import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_messages.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_history_state.dart';
import 'package:event_bus/event_bus.dart';

@LazySingleton()
class TransactionHistoryCubit extends Cubit<TransactionHistoryState> {
  final TransactionRepository _transactionRepository;
  final EventBus _eventBus;
  late final StreamSubscription<dynamic> _refreshSubscription;
  late final StreamSubscription<dynamic> _sessionExpiredSubscription;
  final _log = Logger('TransactionHistoryCubit');

  TransactionHistoryCubit(this._transactionRepository, this._eventBus)
    : super(TransactionHistoryInitial()) {
    _refreshSubscription = _eventBus.on<TransactionChangesEvent>().listen(
      (_) => getFreshTransactionHistory(),
    );
    
    _sessionExpiredSubscription = _eventBus.on<SessionExpiredEvent>().listen(
      (_) {
        // Reset state when session expires to prevent retry loops
        emit(TransactionHistoryInitial());
      },
    );
  }

  Future<void> getFreshTransactionHistory({
    String? search,
    CategoryEntity? categoryEntity,
    int? month,
    int? year,
  }) async {
    emit(TransactionHistoryLoading());

    try {
      final result = await _transactionRepository.getTransactions(
        page: 1,
        search: search,
        categoryId: categoryEntity?.id,
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
    } on UnauthorizedException catch (e) {
      _log.severe('Error fetching transaction history', e);
      emit(TransactionHistoryError(e.message));
    } on UnexpectedException catch (e) {
      _log.severe('Error fetching transaction history', e);
      emit(TransactionHistoryError(e.message));
    } catch (e) {
      _log.severe('Error fetching transaction history', e);
      if (kDebugMode) {
        emit(TransactionHistoryError('Ada kendala: ${e.toString()}'));
      } else {
        emit(
          TransactionHistoryError(
            AppMessages.unknownError,
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
        final result = await _transactionRepository.getTransactions(
          page: page,
          search: search,
          categoryId: categoryEntity?.id,
          month: month,
          year: year,
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
            emit(TransactionHistoryError('Ada kendala: ${e.toString()}'));
        } else {
          emit(
            TransactionHistoryError(
                AppMessages.unknownError,
            ),
          );
        }
      }
    }
  }

  @override
  Future<void> close() {
    _refreshSubscription.cancel();
    _sessionExpiredSubscription.cancel();
    return super.close();
  }
}