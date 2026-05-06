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
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool isLoadingMore;

  NotificationCenterSuccess({
    required this.allNotifications,
    required this.selectedFilter,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    this.isLoadingMore = false,
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

  bool get hasMore => currentPage < totalPages;

  NotificationCenterSuccess copyWith({
    List<NotificationEntity>? allNotifications,
    NotificationCenterFilter? selectedFilter,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    bool? isLoadingMore,
  }) {
    return NotificationCenterSuccess(
      allNotifications: allNotifications ?? this.allNotifications,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
