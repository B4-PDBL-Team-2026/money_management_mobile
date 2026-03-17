import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

sealed class AddTransactionState {}

final class AddTransactionInitial extends AddTransactionState {}

final class AddTransactionLoading extends AddTransactionState {}

final class AddTransactionSuccess extends AddTransactionState {
  final TransactionEntity transaction;

  AddTransactionSuccess(this.transaction);
}

final class AddTransactionError extends AddTransactionState {
  final String message;

  AddTransactionError(this.message);
}
