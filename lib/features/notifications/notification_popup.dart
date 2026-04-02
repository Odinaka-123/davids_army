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
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // 🔥 Drop from top BUT stop slightly lower (natural feel)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2), // start off screen
      end: const Offset(0, 0), // settle position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // ✅ ONLY listen for NEW notifications
    NotificationService().popupStream.addListener(_onNewNotification);
  }

  void _onNewNotification() async {
    final notif = NotificationService().popupStream.value;
    if (notif == null) return;

    setState(() => _current = notif);

    await _controller.forward(from: 0);

    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;
      await _controller.reverse();
      if (mounted) setState(() => _current = null);
    });
  }

  @override
  void dispose() {
    NotificationService().popupStream.removeListener(_onNewNotification);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_current == null) return const SizedBox.shrink();

    return Positioned(
      top: 60, // 🔥 THIS makes it drop and stop nicely below status bar
      left: 16,
      right: 16,
      child: Dismissible(
        key: ValueKey(_current),
        direction: DismissDirection.up,
        onDismissed: (_) => setState(() => _current = null),
        child: GestureDetector(
          onTap: () {
            final notif = _current!;

            NotificationService().markAsRead(notif);

            if (notif.route.isNotEmpty) {
              GoRouter.of(context).push(notif.route);
            }

            setState(() => _current = null);
          },
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.96),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 25,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _current!.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _current!.message,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
