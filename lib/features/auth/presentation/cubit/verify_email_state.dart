sealed class VerifyEmailState {}

class VerifyEmailInitial extends VerifyEmailState {}

class VerifyEmailLoading extends VerifyEmailState {}

class VerifyEmailSuccess extends VerifyEmailState {
  final String message;

  VerifyEmailSuccess(this.message);
}

class VerifyEmailError extends VerifyEmailState {
  final String message;

  VerifyEmailError(this.message);
}
