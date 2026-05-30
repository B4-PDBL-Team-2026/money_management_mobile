sealed class GoogleAuthState {}

final class GoogleAuthInitial extends GoogleAuthState {}

final class GoogleAuthLoading extends GoogleAuthState {}

final class GoogleAuthSuccess extends GoogleAuthState {
  final bool requiresOnboarding;

  GoogleAuthSuccess({required this.requiresOnboarding});
}

final class GoogleAuthError extends GoogleAuthState {
  final String message;

  GoogleAuthError(this.message);
}
