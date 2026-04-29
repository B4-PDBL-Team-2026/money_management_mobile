import 'package:money_management_mobile/features/notification/domain/entities/notification_entity.dart';

enum NotificationCenterFilter { all, unread, read }

sealed class NotificationCenterState {}

class NotificationCenterInitial extends NotificationCenterState {}

class NotificationCenterLoading extends NotificationCenterState {}

class NotificationCenterError extends NotificationCenterState {
  final String message;

  NotificationCenterError(this.message);
}

class NotificationCenterSuccess extends NotificationCenterState {
  final List<NotificationEntity> allNotifications;
  final NotificationCenterFilter selectedFilter;

  NotificationCenterSuccess({
    required this.allNotifications,
    required this.selectedFilter,
  });

  List<NotificationEntity> get visibleNotifications {
    switch (selectedFilter) {
      case NotificationCenterFilter.unread:
        return allNotifications.where((item) => !item.isRead).toList();
      case NotificationCenterFilter.read:
        return allNotifications.where((item) => item.isRead).toList();
      case NotificationCenterFilter.all:
        return allNotifications;
    }
  }

  NotificationCenterSuccess copyWith({
    List<NotificationEntity>? allNotifications,
    NotificationCenterFilter? selectedFilter,
  }) {
    return NotificationCenterSuccess(
      allNotifications: allNotifications ?? this.allNotifications,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
