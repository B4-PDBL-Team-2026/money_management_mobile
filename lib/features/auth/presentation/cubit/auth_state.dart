import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthRegisterSuccess extends AuthState {}

final class AuthLoginSuccess extends AuthState {
  final UserEntity user;
  final String token;

  AuthLoginSuccess({required this.user, required this.token});
}

final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
