import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'home_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(), // Home
    Placeholder(), // Directory
    Placeholder(), // Resources
    Placeholder(), // Events
    Placeholder(), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: NavigationBar(
        height: 72,
        elevation: 3,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
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
            icon: Icon(Iconsax.folder),
            selectedIcon: Icon(Iconsax.folder_open),
            label: 'Resources',
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
    );
  }
}
