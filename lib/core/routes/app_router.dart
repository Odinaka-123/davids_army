import 'package:go_router/go_router.dart';
import '../../features/auth/auth_page.dart';
import '../../features/home/home_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/sermons/sermons_screen.dart';
import '../../features/auth/auth_service.dart';
import '../../features/settings/profile_page.dart';
import '../../features/settings/edit_profile_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/auth', // start at AuthPage
    routes: [
      /// AUTH ROUTE
      GoRoute(path: '/auth', builder: (context, state) => const AuthPage()),

      /// SHELL ROUTE for Home & Sermons
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/sermons',
            builder: (context, state) => const SermonsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/edit-profile',
            builder: (context, state) => const EditProfilePage(),
          ),
        ],
      ),
    ],

    /// REDIRECT BASED ON LOGIN STATE
    redirect: (context, state) {
      final loggedIn = AuthService().isLoggedIn;
      final goingToAuth = state.uri.path == '/auth';

      // Not logged in → force AuthPage
      if (!loggedIn && !goingToAuth) return '/auth';

      // Logged in → skip AuthPage
      if (loggedIn && goingToAuth) return '/';

      return null; // no redirect
    },
  );
}
