import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> register(String name, String email, String password);
  Future<(UserEntity, String)> login(String email, String password);
  Future<void> saveSession(UserEntity user, String token);
  (UserEntity, String)? getSavedSession();
  String? getToken();
  Future<void> clearSession();
}
