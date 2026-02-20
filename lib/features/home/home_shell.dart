import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';

class HomeShell extends StatelessWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  int _locationToIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/sermons')) return 2;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 2:
        context.go('/sermons');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _locationToIndex(context);

    return Scaffold(
      body: child,

      /// 🔽 Floating modern nav
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: NavigationBar(
            height: 70,
            elevation: 12,
            backgroundColor: Colors.white,
            selectedIndex: currentIndex,
            onDestinationSelected: (index) => _onTap(context, index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Iconsax.home_2),
                selectedIcon: Icon(Iconsax.home_25),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.book),
                selectedIcon: Icon(Iconsax.book_1),
                label: 'Directory',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.video),
                selectedIcon: Icon(Iconsax.video_play),
                label: 'Sermons',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.calendar),
                selectedIcon: Icon(Iconsax.calendar_1),
                label: 'Events',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.user),
                selectedIcon: Icon(Iconsax.user_octagon),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
