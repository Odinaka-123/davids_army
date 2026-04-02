import 'package:flutter/foundation.dart';
import '../../models/app_notification.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<AppNotification> _notifications = [];

  // 🔥 ONLY used for popup trigger
  final ValueNotifier<AppNotification?> popupStream = ValueNotifier(null);

  List<AppNotification> get notifications => _notifications.reversed.toList();

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void addNotification(AppNotification notification) {
    _notifications.add(notification);

    popupStream.value = notification; // ✅ ONLY here triggers popup

    notifyListeners(); // for UI (bell, page)
  }

  void markAsRead(AppNotification notification) {
    notification.isRead = true;
    notifyListeners(); // ❌ no popup
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners(); // ❌ no popup
  }

  void clear() {
    _notifications.clear();
    notifyListeners();
  }
}
