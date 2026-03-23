import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';

sealed class SessionState {}

final class SessionUnauthenticated extends SessionState {}

final class SessionAuthenticated extends SessionState {
  final UserEntity user;
  final String token;
  final bool requiresOnboarding;

  SessionAuthenticated({
    required this.user,
    required this.token,
    required this.requiresOnboarding,
  });

  SessionAuthenticated copyWith({
    UserEntity? user,
    String? token,
    bool? requiresOnboarding,
  }) {
    return SessionAuthenticated(
      user: user ?? this.user,
      token: token ?? this.token,
      requiresOnboarding: requiresOnboarding ?? this.requiresOnboarding,
    );
  }
}
