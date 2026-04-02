import 'package:flutter/material.dart';
import '../../core/services/notification_service.dart';
import '../../models/app_notification.dart';
import '../../core/utils/time_ago.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = NotificationService();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          AnimatedBuilder(
            animation: service,
            builder: (_, __) {
              if (service.notifications.isEmpty) return const SizedBox();
              return TextButton(
                onPressed: service.markAllAsRead,
                child: const Text("Mark all read"),
              );
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: service,
        builder: (_, __) {
          final notifications = service.notifications;

          if (notifications.isEmpty) {
            return Center(
              child: Text(
                "No notifications yet",
                style: TextStyle(color: colors.onBackground.withOpacity(0.6)),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return _card(context, notif);
            },
          );
        },
      ),
    );
  }

  Widget _card(BuildContext context, AppNotification notif) {
    final colors = Theme.of(context).colorScheme;
    final service = NotificationService();

    IconData icon;
    Color iconColor;

    switch (notif.type) {
      case NotificationType.event:
        icon = Icons.event;
        iconColor = Colors.orange;
        break;
      case NotificationType.message:
        icon = Icons.chat;
        iconColor = Colors.green;
        break;
      case NotificationType.alert:
        icon = Icons.warning;
        iconColor = Colors.red;
        break;
      default:
        icon = Icons.notifications;
        iconColor = colors.primary;
    }

    return GestureDetector(
      onTap: () {
        service.markAsRead(notif);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notif.isRead
              ? colors.surface
              : colors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: notif.isRead
              ? null
              : Border.all(color: colors.primary.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif.title,
                    style: TextStyle(
                      fontWeight: notif.isRead
                          ? FontWeight.w500
                          : FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.message,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            Text(
              timeAgo(notif.createdAt),
              style: TextStyle(
                fontSize: 11,
                color: colors.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
