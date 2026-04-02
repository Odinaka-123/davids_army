enum NotificationType { general, event, message, alert }

class AppNotification {
  final String title;
  final String message;
  final String route;
  final DateTime createdAt;
  final NotificationType type;

  bool isRead;

  AppNotification({
    required this.title,
    required this.message,
    this.route = '',
    this.type = NotificationType.general,
    DateTime? createdAt,
    this.isRead = false,
  }) : createdAt = createdAt ?? DateTime.now();
}
