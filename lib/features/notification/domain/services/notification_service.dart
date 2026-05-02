import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationBootstrapResult {
  final String? token;
  final bool isPermissionGranted;

  NotificationBootstrapResult({
    required this.token,
    required this.isPermissionGranted,
  });
}

abstract class NotificationService {
  Stream<RemoteMessage> get foregroundMessages;
  Stream<RemoteMessage> get openedMessages;
  Stream<String> get tokenRefreshes;

  Future<NotificationBootstrapResult> initialize();

  void dispose();
}
