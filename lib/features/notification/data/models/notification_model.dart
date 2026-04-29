import 'package:money_management_mobile/features/notification/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.createdAt,
    required super.title,
    required super.message,
    required super.isRead,
    required super.notificationCode,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final rawCode =
        json['notificationCode'] as String? ??
        json['notification_code'] as String?;

    return NotificationModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      title: json['title'] as String,
      message: json['message'] as String,
      isRead: json['isRead'] as bool,
      notificationCode:
          NotificationCode.fromValue(rawCode) ??
          NotificationCode.transactionRecordingReminder,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'title': title,
      'message': message,
      'isRead': isRead,
      'notificationCode': notificationCode.value,
    };
  }

  NotificationModel copyWith({
    String? id,
    DateTime? createdAt,
    String? title,
    String? message,
    bool? isRead,
    NotificationCode? notificationCode,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      notificationCode: notificationCode ?? this.notificationCode,
    );
  }
}
