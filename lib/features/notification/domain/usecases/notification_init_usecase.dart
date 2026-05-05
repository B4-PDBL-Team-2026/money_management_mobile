import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/features/notification/domain/entities/notification_registration_entity.dart';
import 'package:money_management_mobile/features/notification/domain/repositories/notification_center_repository.dart';
import 'package:money_management_mobile/features/notification/domain/services/device_service.dart';
import 'package:money_management_mobile/features/notification/domain/services/notification_service.dart';

@LazySingleton()
class NotificationInitUsecase {
  final Logger _log = Logger('NotificationInitUsecase');
  final NotificationService _notificationService;
  final DeviceService _deviceService;
  final NotificationCenterRepository _notificationCenterRepository;

  NotificationInitUsecase(
    this._notificationService,
    this._deviceService,
    this._notificationCenterRepository,
  );

  StreamSubscription<String>? onTokenRefresh;
  DeviceInfo? _cachedDeviceInfo;

  Future<bool> execute() async {
    final result = await _notificationService.initialize();

    if (!result.isPermissionGranted || result.token == null) {
      _log.warning('Failed to initialize notification service.');
      return false;
    }

    await _registerDeviceToNotification(result.token!);

    onTokenRefresh ??= _notificationService.tokenRefreshes.listen(
      _registerDeviceToNotification,
    );

    return result.isPermissionGranted;
  }

  Future<void> _registerDeviceToNotification(String token) async {
    _log.info('FCM token obtained: $token');
    _cachedDeviceInfo ??= await _deviceService.getDeviceInfo();

    final registeredDevices = await _notificationCenterRepository
        .getRegisteredDevices();
    final deviceId = _cachedDeviceInfo!.deviceId;
    String? existingToken;

    for (final registration in registeredDevices) {
      if (registration.deviceId == deviceId) {
        existingToken = registration.token;
        break;
      }
    }

    _log.info('Server FCM token for device $deviceId: $existingToken');

    if (existingToken == null ||
        existingToken.isEmpty ||
        existingToken != token) {
      _log.info('Registering device for notifications.');
      await _notificationCenterRepository.registerDeviceForNotifications(
        NotificationRegistrationEntity(
          deviceId: _cachedDeviceInfo!.deviceId,
          token: token,
          deviceType: _cachedDeviceInfo!.deviceType,
        ),
      );
    }
  }

  @disposeMethod
  void dispose() {
    onTokenRefresh?.cancel();
    onTokenRefresh = null;
  }
}
