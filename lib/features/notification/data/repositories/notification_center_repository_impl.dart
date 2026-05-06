import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/core/domain/entities/paginated_entity.dart';
import 'package:money_management_mobile/features/notification/data/data_sources/remote/notification_remote_data_source.dart';
import 'package:money_management_mobile/features/notification/data/models/notification_registration_model.dart';
import 'package:money_management_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:money_management_mobile/features/notification/domain/entities/notification_registration_entity.dart';
import 'package:money_management_mobile/features/notification/domain/repositories/notification_center_repository.dart';

@LazySingleton(as: NotificationCenterRepository)
class NotificationCenterRepositoryImpl implements NotificationCenterRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationCenterRepositoryImpl(this._remoteDataSource);

  @override
  Future<PaginatedEntity<NotificationEntity>> getNotifications({
    int? page,
    int? perPage,
  }) async {
    final model = await _remoteDataSource.getNotifications(
      page: page,
      perPage: perPage,
    );
    return model.toEntity((item) => item.toEntity());
  }

  @override
  Future<void> dismissNotification(String notificationId) async {
    await _remoteDataSource.dismissNotification(notificationId);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _remoteDataSource.markAsRead(notificationId);
  }

  @override
  Future<List<NotificationRegistrationEntity>> getRegisteredDevices() async {
    return _remoteDataSource.getRegisteredDevices();
  }

  @override
  Future<void> registerDeviceForNotifications(
    NotificationRegistrationEntity registrationData,
  ) async {
    final model = NotificationRegistrationModel.fromEntity(registrationData);

    await _remoteDataSource.registerNotificationToken(model);
  }
}
