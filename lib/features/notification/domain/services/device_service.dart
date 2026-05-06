import 'package:money_management_mobile/features/notification/domain/entities/notification_registration_entity.dart';

class DeviceInfo {
  final String deviceId;
  final DeviceType deviceType;

  DeviceInfo({required this.deviceId, required this.deviceType});
}

abstract class DeviceService {
  Future<DeviceInfo> getDeviceInfo();
}
