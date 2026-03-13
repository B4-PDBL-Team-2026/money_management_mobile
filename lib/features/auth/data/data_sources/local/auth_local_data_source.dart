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

  AuthLocalDataSource(this.sharedPreferences);

  Future<void> saveSession(UserEntity user, String token) async {
    _log.fine('Saving auth session to local storage');

    final userModel = UserModel.fromEntity(user);

    await Future.wait([
      sharedPreferences.setString(_keyToken, token),
      sharedPreferences.setString(_keyUser, userModel.toRawJson()),
    ]);

    _log.fine('Auth session saved successfully');
  }

  String? getToken() {
    final token = sharedPreferences.getString(_keyToken);

    _log.fine(
      'Retrieved auth token from local storage: ${token != null ? '[present]' : '[absent]'}',
    );

    return token;
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

  (UserEntity, String)? getSession() {
    final user = getUser();
    final token = getToken();

    if (user == null || token == null) {
      _log.fine('Auth session is incomplete in local storage');
      return null;
    }

    return (user, token);
  }

  Future<void> clearSession() async {
    _log.fine('Clearing auth session from local storage');

    await Future.wait([
      sharedPreferences.remove(_keyToken),
      sharedPreferences.remove(_keyUser),
    ]);

    _log.fine('Auth session cleared successfully');
  }
}
