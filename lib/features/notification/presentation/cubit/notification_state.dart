sealed class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationInitializing extends NotificationState {}

class NotificationReady extends NotificationState {
  final String? token;
  final bool isPermissionGranted;
  final String? lastOpenedRoute;

  NotificationReady({
    required this.isPermissionGranted,
    this.token,
    this.lastOpenedRoute,
  });

  NotificationReady copyWith({
    String? token,
    bool? isPermissionGranted,
    String? lastOpenedRoute,
  }) {
    return NotificationReady(
      token: token ?? this.token,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      lastOpenedRoute: lastOpenedRoute ?? this.lastOpenedRoute,
    );
  }
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
