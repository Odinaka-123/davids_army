import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';

class HomeShell extends StatelessWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  int _locationToIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/sermons')) return 2;
    if (location.startsWith('/events')) return 3;
    if (location.startsWith('/profile')) return 4;
    if (location.startsWith('/directory')) return 1;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/directory');
        break;
      case 2:
        context.go('/sermons');
        break;
      case 3:
        context.go('/events');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _locationToIndex(context);
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      body: child,
      bottomNavigationBar: Padding(
        // Add bottom padding so bar floats above system navigation
        padding: EdgeInsets.fromLTRB(32, 0, 32, 16 + bottomPadding),
        child: Material(
          elevation: 12,
          borderRadius: BorderRadius.circular(40),
          color: Colors.white,
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
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
                  icon: Iconsax.book,
                  selectedIcon: Iconsax.book_1,
                  index: 1,
                  currentIndex: currentIndex,
                  context: context,
                ),
                _buildNavItem(
                  icon: Iconsax.video,
                  selectedIcon: Iconsax.video_play,
                  index: 2,
                  currentIndex: currentIndex,
                  context: context,
                ),
                _buildNavItem(
                  icon: Iconsax.calendar,
                  selectedIcon: Iconsax.calendar_1,
                  index: 3,
                  currentIndex: currentIndex,
                  context: context,
                ),
                _buildNavItem(
                  icon: Iconsax.user,
                  selectedIcon: Iconsax.user_octagon,
                  index: 4,
                  currentIndex: currentIndex,
                  context: context,
                ),
              ],
            ),
          ),
        ),
      ),
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

    return GestureDetector(
      onTap: () => _onTap(context, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSelected ? selectedIcon : icon,
          size: isSelected ? 32 : 28,
          color: isSelected
              ? const Color.fromARGB(255, 1, 65, 10)
              : Colors.grey.shade600,
        ),
      ),
    );
  }
}
