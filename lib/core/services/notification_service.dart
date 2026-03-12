// lib/core/services/notification_service.dart
import 'package:flutter/foundation.dart';
import '../../models/app_notification.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<AppNotification> _notifications = [];

  List<AppNotification> get notifications => _notifications.reversed.toList();

  void addNotification(AppNotification notification) {
    _notifications.add(notification);
    notifyListeners(); // 🔑 triggers popup
  }
}
