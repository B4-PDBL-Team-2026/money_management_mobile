import 'package:money_management_mobile/features/notification/domain/entities/notification_entity.dart';

class NotificationPayload {
  final NotificationCode code;
  final String? targetId;

  NotificationPayload({required this.code, this.targetId});
}

class NotificationBootstrapResult {
  final String? token;
  final bool isPermissionGranted;

  NotificationBootstrapResult({
    required this.token,
    required this.isPermissionGranted,
  });
}

abstract class NotificationService {
  Stream<NotificationPayload> get foregroundMessages;
  Stream<NotificationPayload> get openedMessages;
  Stream<String> get tokenRefreshes;

  Future<NotificationBootstrapResult> initialize();

  void dispose();
}
