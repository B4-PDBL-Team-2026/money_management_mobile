enum DeviceType {
  android('android'),
  ios('ios');

  final String value;

  const DeviceType(this.value);
}

class NotificationRegistrationEntity {
  final String deviceId;
  final String token;
  final DeviceType deviceType;

  NotificationRegistrationEntity({
    required this.deviceId,
    required this.token,
    required this.deviceType,
  });
}