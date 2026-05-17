sealed class BatchTransactionSubmitState {}

final class BatchTransactionSubmitInitial extends BatchTransactionSubmitState {}

final class BatchTransactionSubmitLoading extends BatchTransactionSubmitState {}

final class BatchTransactionSubmitSuccess extends BatchTransactionSubmitState {}

final class BatchTransactionSubmitError extends BatchTransactionSubmitState {
  final String message;
  BatchTransactionSubmitError(this.message);
}

final class BatchTransactionSubmitValidationError
    extends BatchTransactionSubmitState {
  final Map<String, dynamic>? errors;
  BatchTransactionSubmitValidationError(this.errors);
}
