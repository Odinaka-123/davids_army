import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../settings/settings_page.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Settings Icon
            IconButton.filledTonal(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
              icon: const Icon(Iconsax.setting_2),
            ),

            // Notification Icon
            Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Iconsax.notification,
                    size: 26,
                    color: colors.onSurface,
                  ),
                ),

                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
