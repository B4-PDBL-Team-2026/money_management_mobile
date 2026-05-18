import 'package:money_management_mobile/features/transaction/domain/entities/batch_transaction_detail_entity.dart';

sealed class BatchTransactionDetailState {}

class BatchTransactionDetailInitial extends BatchTransactionDetailState {}

class BatchTransactionDetailLoading extends BatchTransactionDetailState {}

class BatchTransactionDetailSuccess extends BatchTransactionDetailState {
  final BatchTransactionDetailEntity detail;

  BatchTransactionDetailSuccess(this.detail);
}

class BatchTransactionDetailError extends BatchTransactionDetailState {
  final String message;

  BatchTransactionDetailError(this.message);
}
