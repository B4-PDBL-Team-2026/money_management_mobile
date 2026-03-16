sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthLoginSuccess extends AuthState {
  final bool requiresOnboarding;

  AuthLoginSuccess({required this.requiresOnboarding});
}

final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
