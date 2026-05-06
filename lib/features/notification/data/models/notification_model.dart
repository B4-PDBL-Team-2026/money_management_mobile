import 'package:money_management_mobile/features/notification/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.createdAt,
    required super.title,
    required super.message,
    required super.isRead,
    required super.notificationCode,
    super.targetId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final payload =
        json['payload'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final rawCode =
        payload['notificationCode'] as String? ??
        payload['notification_code'] as String? ??
        json['notificationCode'] as String? ??
        json['notification_code'] as String?;
    // TODO: mengganti occurrenceId dengan targetId di backend agar lebih generic
    final targetId =
        payload['occurrenceId']?.toString() ??
        payload['occurrence_id']?.toString();
    final createdAt = _parseDateTime(json['createdAt'] ?? json['created_at']);
    final isRead = _parseBool(json['isRead'] ?? json['is_read']);

    return NotificationModel(
      id: json['id'] as String,
      createdAt: createdAt,
      title: json['title'] as String,
      message: json['message'] as String,
      isRead: isRead,
      notificationCode:
          NotificationCode.fromValue(rawCode) ??
          NotificationCode.transactionRecordingReminder,
      targetId: targetId,
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      createdAt: createdAt,
      title: title,
      message: message,
      isRead: isRead,
      notificationCode: notificationCode,
      targetId: targetId,
    );
  }

  NotificationModel copyWith({
    String? id,
    DateTime? createdAt,
    String? title,
    String? message,
    bool? isRead,
    NotificationCode? notificationCode,
    String? targetId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      notificationCode: notificationCode ?? this.notificationCode,
      targetId: targetId ?? this.targetId,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }
    return DateTime.now();
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }
}
