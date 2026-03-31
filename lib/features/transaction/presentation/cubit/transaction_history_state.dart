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
  final bool isLoadingMore;

  TransactionHistorySuccess(
    this.transactionHistory,
    this.currentPage,
    this.totalPages,
    this.totalItems, {
    this.isLoadingMore = false,
  });

  TransactionHistorySuccess copyWith({
    List<TransactionHistoryEntity>? transactionHistory,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    bool? isLoadingMore,
  }) {
    return TransactionHistorySuccess(
      transactionHistory ?? this.transactionHistory,
      currentPage ?? this.currentPage,
      totalPages ?? this.totalPages,
      totalItems ?? this.totalItems,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
