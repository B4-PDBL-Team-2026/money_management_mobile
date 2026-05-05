import 'package:money_management_mobile/features/notification/domain/entities/notification_registration_entity.dart';

class NotificationRegistrationModel extends NotificationRegistrationEntity {
  NotificationRegistrationModel({
    required super.deviceId,
    required super.token,
    required super.deviceType,
  });

  factory NotificationRegistrationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final deviceTypeValue = json['deviceType'];
    final normalizedDeviceType = deviceTypeValue
        ?.toString()
        .trim()
        .toLowerCase();
    final deviceType = DeviceType.values.firstWhere(
      (type) => type.value == normalizedDeviceType,
      orElse: () => DeviceType.android,
    );

    return NotificationRegistrationModel(
      deviceId: json['deviceId']?.toString() ?? '',
      token: (json['fcmToken'] ?? json['token'])?.toString() ?? '',
      deviceType: deviceType,
    );
  }

  factory NotificationRegistrationModel.fromEntity(
    NotificationRegistrationEntity entity,
  ) {
    return NotificationRegistrationModel(
      deviceId: entity.deviceId,
      token: entity.token,
      deviceType: entity.deviceType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'fcmToken': token,
      'deviceType': deviceType.value,
    };
  }
}
