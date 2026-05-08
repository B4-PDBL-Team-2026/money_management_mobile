sealed class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationInitializing extends NotificationState {}

class NotificationReady extends NotificationState {}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
