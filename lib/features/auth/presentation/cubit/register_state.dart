sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final bool requiresOnboarding;

  RegisterSuccess({required this.requiresOnboarding});
}

final class RegisterError extends RegisterState {
  final String message;

  RegisterError(this.message);
}

final class RegisterValidationError extends RegisterState {
  final String message;
  final Map<String, dynamic>? errors;

  RegisterValidationError(this.message, {this.errors});
}
