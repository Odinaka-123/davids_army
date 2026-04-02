import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import '../../settings/settings_page.dart';
import '../../../core/widgets/notification_bell.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// ⚙️ Settings
            IconButton.filledTonal(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
              icon: const Icon(Iconsax.setting_2),
            ),

            /// 🔔 Notifications (REAL)
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  context.push('/notifications');
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: NotificationBell(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
