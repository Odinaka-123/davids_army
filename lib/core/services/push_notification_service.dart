import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/notification_service.dart';
import '../../models/app_notification.dart';

/// 🔥 REQUIRED for background handling
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("🔔 Background message: ${message.notification?.title}");
}

class PushNotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static Future<void> init() async {
    // 🔐 Ask permission
    await _fcm.requestPermission();

    // 🔥 Get token (for testing / future use)
    final token = await _fcm.getToken();
    print("🔥 FCM TOKEN: $token");

    // ✅ Subscribe EVERY user to global topic
    await _fcm.subscribeToTopic("all_users");

    // 🔥 BACKGROUND HANDLER
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    /// 🧠 FOREGROUND (app open)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "Notification";
      final body = message.notification?.body ?? "";

      NotificationService().addNotification(
        AppNotification(
          title: title,
          message: body,
          type: NotificationType.alert,
          route: message.data['route'] ?? "", // 🔥 deep link support
        ),
      );
    });

    /// 📲 When user taps notification (background)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("📲 Notification clicked");

      final route = message.data['route'];
      if (route != null) {
        // You’ll handle navigation globally (later step)
        print("➡️ Navigate to: $route");
      }
    });

    /// 📴 App opened from TERMINATED state
    final initialMessage = await _fcm.getInitialMessage();

    if (initialMessage != null) {
      print("🚀 App opened from terminated via notification");
    }
  }
}
