import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:money_management_mobile/features/auth/data/models/user_model.dart';
import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final _log = Logger('AuthLocalDataSource');

  static const _keyToken = 'auth_token';
  static const _keyUser = 'auth_user';
  static const _keyRequiresOnboarding = 'auth_requires_onboarding';

  AuthLocalDataSource(this.sharedPreferences);

  String? getToken() {
    final token = sharedPreferences.getString(_keyToken);

    _log.fine(
      'Retrieved auth token from local storage: ${token != null ? '[present]' : '[absent]'}',
    );

    return token;
  }

  Future<void> storeToken(String token) async {
    await sharedPreferences.setString(_keyToken, token);
  }

  UserEntity? getUser() {
    final rawUser = sharedPreferences.getString(_keyUser);

    if (rawUser == null) {
      _log.fine('Retrieved auth user from local storage: [absent]');
      return null;
    }

    _log.fine('Retrieved auth user from local storage: [present]');
    return UserModel.fromJson(jsonDecode(rawUser) as Map<String, dynamic>);
  }

  Future<void> storeUser(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await sharedPreferences.setString(_keyUser, userModel.toRawJson());
  }

  bool? getRequiresOnboarding() {
    return sharedPreferences.getBool(_keyRequiresOnboarding);
  }

  Future<void> storeRequiresOnboarding(bool requiresOnboarding) async {
    await sharedPreferences.setBool(_keyRequiresOnboarding, requiresOnboarding);
  }

  Future<void> clearAll() async {
    _log.fine('Clearing all auth data from local storage');

    await Future.wait([
      sharedPreferences.remove(_keyToken),
      sharedPreferences.remove(_keyUser),
      sharedPreferences.remove(_keyRequiresOnboarding),
    ]);

    _log.fine('All auth data cleared successfully');
  }
}
