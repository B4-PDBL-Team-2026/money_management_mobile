import 'package:money_management_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:money_management_mobile/features/notification/domain/entities/notification_registration_entity.dart';

abstract class NotificationCenterRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> dismissNotification(String notificationId);
  Future<void> markAsRead(String notificationId);
  Future<String?> getRegisteredToken();
  Future<void> registerDeviceForNotifications(
    NotificationRegistrationEntity registrationData,
  );
}
