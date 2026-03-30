import 'package:money_management_mobile/features/transaction/domain/entities/transaction_detail_entity.dart';

sealed class TransactionDetailState {}

class TransactionDetailInitial extends TransactionDetailState {}

class TransactionDetailLoading extends TransactionDetailState {}

class TransactionDetailSuccess extends TransactionDetailState {
  final TransactionDetailEntity transactionDetail;

  TransactionDetailSuccess(this.transactionDetail);
}

class TransactionDetailError extends TransactionDetailState {
  final String message;

  TransactionDetailError(this.message);
}
