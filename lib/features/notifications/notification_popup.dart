import 'package:flutter/material.dart';
import '../../core/services/notification_service.dart';
import '../../models/app_notification.dart';
import 'package:go_router/go_router.dart';

class NotificationPopup extends StatefulWidget {
  const NotificationPopup({super.key});

  @override
  State<NotificationPopup> createState() => _NotificationPopupState();
}

class _NotificationPopupState extends State<NotificationPopup>
    with SingleTickerProviderStateMixin {
  AppNotification? _current;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Listen to notifications
    NotificationService().addListener(_showLatest);
  }

  void _showLatest() {
    final notifications = NotificationService().notifications;
    if (notifications.isEmpty) return;

    setState(() => _current = notifications.first);

    _controller.forward();

    // Auto-dismiss
    Future.delayed(const Duration(seconds: 3), () async {
      await _controller.reverse();
      if (mounted) setState(() => _current = null);
    });
  }

  @override
  void dispose() {
    NotificationService().removeListener(_showLatest);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_current == null) return const SizedBox.shrink();

    return Positioned(
      top: 50,
      right: 16,
      child: GestureDetector(
        onTap: () {
          final route = _current!.route;
          if (route.isNotEmpty) {
            // ✅ Ensure navigation happens on the root context
            GoRouter.of(context).go(route);
            setState(() => _current = null);
          }
        },
        child: SlideTransition(
          position: _slideAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _current!.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _current!.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
