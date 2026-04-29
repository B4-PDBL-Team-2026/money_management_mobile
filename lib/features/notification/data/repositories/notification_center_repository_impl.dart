import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/notification/data/data_sources/remote/notification_remote_data_source.dart';
import 'package:money_management_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:money_management_mobile/features/notification/domain/repositories/notification_center_repository.dart';

@LazySingleton(as: NotificationCenterRepository)
class NotificationCenterRepositoryImpl implements NotificationCenterRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationCenterRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final models = await _remoteDataSource.getNotifications();
    return models.map((item) => item.toEntity()).toList();
  }

  @override
  Future<void> dismissNotification(String notificationId) async {
    await _remoteDataSource.dismissNotification(notificationId);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _remoteDataSource.markAsRead(notificationId);
  }
}
