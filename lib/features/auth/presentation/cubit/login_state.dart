sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final bool requiresOnboarding;

  LoginSuccess({required this.requiresOnboarding});
}

final class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}

final class LoginValidationError extends LoginState {
  final Map<String, dynamic>? errors;

  LoginValidationError(this.errors);
}
