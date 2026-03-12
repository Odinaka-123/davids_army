import 'package:flutter/material.dart';
import '../../core/services/notification_service.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = NotificationService().notifications;

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: notifications.isEmpty
          ? const Center(child: Text("No notifications yet"))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];

                return ListTile(
                  title: Text(notif.title),
                  subtitle: Text(notif.message),
                );
              },
            ),
    );
  }
}
