import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/notification_service.dart';
import '../../models/app_notification.dart';

class PushNotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static Future<void> init() async {
    // 🔐 Ask permission
    await _fcm.requestPermission();

    // 🔥 Get device token
    final token = await _fcm.getToken();
    print("🔥 YOUR FCM TOKEN:");
    print(token);

    // 🧠 FOREGROUND (app open)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "Notification";
      final body = message.notification?.body ?? "";

      NotificationService().addNotification(
        AppNotification(
          title: title,
          message: body,
          type: NotificationType.alert,
        ),
      );
    });

    // 📴 BACKGROUND (when tapped)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("User opened notification");
    });
  }
}
