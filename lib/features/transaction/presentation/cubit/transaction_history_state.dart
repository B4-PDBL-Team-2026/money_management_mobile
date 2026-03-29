import 'package:money_management_mobile/features/transaction/domain/entities/transaction_history_entity.dart';

sealed class TransactionHistoryState {}

class TransactionHistoryInitial extends TransactionHistoryState {}

class TransactionHistoryLoading extends TransactionHistoryState {}

class TransactionHistoryError extends TransactionHistoryState {
  final String message;
  TransactionHistoryError(this.message);
}

class TransactionHistorySuccess extends TransactionHistoryState {
  final List<TransactionHistoryEntity> transactionHistory;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  TransactionHistorySuccess(
    this.transactionHistory,
    this.currentPage,
    this.totalPages,
    this.totalItems,
  );
}
