import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';

sealed class SessionState {}

final class SessionUnauthenticated extends SessionState {}

final class SessionAuthenticated extends SessionState {
  final UserEntity user;
  final String token;

  SessionAuthenticated({required this.user, required this.token});
}