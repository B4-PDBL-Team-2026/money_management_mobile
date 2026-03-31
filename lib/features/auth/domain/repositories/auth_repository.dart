import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<(UserEntity, String, bool)> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  );
  Future<(UserEntity, String, bool)> login(String email, String password);
  Future<void> saveSession(
    UserEntity user,
    String token, {
    required bool requiresOnboarding,
  });
  (UserEntity, String, bool)? getSavedSession();
  String? getToken();
  Future<void> updateRequiresOnboarding(bool requiresOnboarding);
  Future<String> sendPasswordResetEmail(String email);
  Future<String> requestEmailVerification();
  Future<void> clearSession();
}
