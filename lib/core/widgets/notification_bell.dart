import 'package:flutter/material.dart';
import '../../core/services/notification_service.dart';

class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  int _lastCount = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.3,
          end: 0.95,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.95,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 20,
      ),
    ]).animate(_controller);

    NotificationService().addListener(_onNotificationChange);
  }

  void _onNotificationChange() {
    final service = NotificationService();
    final newCount = service.unreadCount;

    if (newCount > _lastCount) {
      _controller.forward(from: 0);
    }

    _lastCount = newCount;
  }

  @override
  void dispose() {
    NotificationService().removeListener(_onNotificationChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = NotificationService();
    final colors = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: Listenable.merge([service, _controller]),
      builder: (_, __) {
        final count = service.unreadCount;

        return Transform.scale(
          scale: _scale.value,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.outline.withOpacity(0.2)),
                ),
                child: Icon(
                  count > 0
                      ? Icons
                            .notifications_active_rounded // 🔥 changes when unread
                      : Icons.notifications_none_rounded,
                  size: 22,
                  color: count > 0
                      ? colors.primary
                      : colors.onSurface.withOpacity(0.7),
                ),
              ),

              if (count > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: colors.error,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colors.error.withOpacity(0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Text(
                      count > 9 ? "9+" : "$count",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
