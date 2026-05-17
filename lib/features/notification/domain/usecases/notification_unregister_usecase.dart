import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/notification/domain/repositories/notification_center_repository.dart';
import 'package:money_management_mobile/features/notification/domain/services/device_service.dart';

@Injectable()
class NotificationUnregisterUsecase {
  final NotificationCenterRepository _notificationCenterRepository;
  final DeviceService _deviceService;

  NotificationUnregisterUsecase(
    this._notificationCenterRepository,
    this._deviceService,
  );

  Future<void> execute() async {
    final deviceInfo = await _deviceService.getDeviceInfo();
    final deviceId = deviceInfo.deviceId;

    if (deviceId.isEmpty) {
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat membatalkan pendaftaran perangkat',
      );
    }

    await _notificationCenterRepository.unregisterDeviceForNotifications(
      deviceId,
    );
  }
}
