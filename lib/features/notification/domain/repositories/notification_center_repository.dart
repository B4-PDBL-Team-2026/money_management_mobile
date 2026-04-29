import 'package:money_management_mobile/features/notification/domain/entities/notification_entity.dart';

abstract class NotificationCenterRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> dismissNotification(String notificationId);
  Future<void> markAsRead(String notificationId);
}
