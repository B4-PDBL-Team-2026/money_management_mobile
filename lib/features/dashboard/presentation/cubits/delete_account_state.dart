sealed class DeleteAccountState {}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountLoading extends DeleteAccountState {}

class DeleteAccountSuccess extends DeleteAccountState {}

class DeleteAccountError extends DeleteAccountState {
  final String message;

  DeleteAccountError(this.message);
}

class DeleteAccountValidationError extends DeleteAccountState {
  final Map<String, dynamic>? fieldError;

  DeleteAccountValidationError(this.fieldError);
}
