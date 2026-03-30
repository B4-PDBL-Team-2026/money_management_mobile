sealed class EmailVerificationState {}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationLoading extends EmailVerificationState {}

class EmailVerificationSuccess extends EmailVerificationState {
  final String message;

  EmailVerificationSuccess(this.message);
}

class EmailVerificationError extends EmailVerificationState {
  final String message;

  EmailVerificationError(this.message);
}
