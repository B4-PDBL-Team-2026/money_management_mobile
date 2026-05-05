enum NotificationCode {
  transactionRecordingReminder('TRANSACTION_RECORDING_REMINDER'),
  fixedCostDue('FIXED_COST_DUE');

  const NotificationCode(this.value);

  final String value;

  static NotificationCode? fromValue(String? value) {
    if (value == null) {
      return null;
    }

    for (final notificationCode in NotificationCode.values) {
      if (notificationCode.value == value) {
        return notificationCode;
      }
    }

    return null;
  }

  String? get routePath {
    switch (this) {
      case NotificationCode.transactionRecordingReminder:
        return '/transaction/add';
      case NotificationCode.fixedCostDue:
        return '/fixed-costs';
    }
  }
}

class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.message,
    required this.isRead,
    required this.notificationCode,
    this.targetId,
  });

  final String id;
  final DateTime createdAt;
  final String title;
  final String message;
  final bool isRead;
  final NotificationCode notificationCode;
  final String? targetId;
}
