class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.message,
    required this.isRead,
  });

  final String id;
  final DateTime createdAt;
  final String title;
  final String message;
  final bool isRead;
}
