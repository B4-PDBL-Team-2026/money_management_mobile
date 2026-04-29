import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton()
class NotificationLocalDataSource {
  static const _fcmTokenKey = 'fcm_token';

  final SharedPreferences sharedPreferences;
  final _log = Logger('NotificationLocalDataSource');

  NotificationLocalDataSource(this.sharedPreferences);

  Future<void> saveFcmToken(String token) async {
    final isSaved = await sharedPreferences.setString(_fcmTokenKey, token);

    if (!isSaved) {
      _log.warning('Failed to persist FCM token in local storage.');
    }
  }

  String? getFcmToken() {
    return sharedPreferences.getString(_fcmTokenKey);
  }

  Future<void> clearFcmToken() async {
    await sharedPreferences.remove(_fcmTokenKey);
  }
}
