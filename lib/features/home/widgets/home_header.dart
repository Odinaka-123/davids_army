import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

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
            // 👤 Profile avatar
            GestureDetector(
              onTap: () {
                // TODO: navigate to profile
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFF1F5F9),
                child: Icon(Iconsax.user, color: Color(0xFF334155)),
              ),
            ),

            // 🔔 Notifications
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    // TODO: open notifications
                  },
                  icon: const Icon(
                    Iconsax.notification,
                    size: 26,
                    color: Color(0xFF334155),
                  ),
                ),

                // 🔴 Red dot badge
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
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
