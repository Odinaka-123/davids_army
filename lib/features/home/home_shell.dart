import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import '../notifications/notification_popup.dart';

class HomeShell extends StatelessWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  int _locationToIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/sermons')) return 1;
    if (location.startsWith('/give')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0; // home
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/sermons');
        break;
      case 2:
        context.go('/give');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _locationToIndex(context);
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final colors = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: colors.surface,
          extendBody: true,
          body: child,

          /// 🔥 UPDATED BOTTOM NAV (4 ITEMS ONLY)
          bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(32, 0, 32, 16 + bottomPadding),
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(40),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Iconsax.home_2,
                    selectedIcon: Iconsax.home_25,
                    index: 0,
                    currentIndex: currentIndex,
                    context: context,
                  ),
                  _buildNavItem(
                    icon: Iconsax.video,
                    selectedIcon: Iconsax.video_play,
                    index: 1,
                    currentIndex: currentIndex,
                    context: context,
                  ),
                  _buildNavItem(
                    icon: Iconsax.money_send,
                    selectedIcon: Iconsax.money_send,
                    index: 2,
                    currentIndex: currentIndex,
                    context: context,
                  ),
                  _buildNavItem(
                    icon: Iconsax.user,
                    selectedIcon: Iconsax.user_octagon,
                    index: 3,
                    currentIndex: currentIndex,
                    context: context,
                  ),
                ],
              ),
            ),
          ),
        ),

        /// 🔔 GLOBAL POPUP
        const NotificationPopup(),
      ],
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required int index,
    required int currentIndex,
    required BuildContext context,
  }) {
    final isSelected = index == currentIndex;
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _onTap(context, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withOpacity(0.1)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSelected ? selectedIcon : icon,
          size: isSelected ? 32 : 28,
          color: isSelected ? colors.primary : colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
