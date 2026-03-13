import 'package:go_router/go_router.dart';
import '../../features/auth/auth_page.dart';
import '../../features/home/home_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/sermons/sermons_screen.dart';
import '../../features/settings/profile_page.dart';
import '../../features/settings/edit_profile_page.dart';
import '../../features/auth/verify_code_page.dart';
import '../../features/auth/auth_service.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/auth',

    routes: [
      GoRoute(path: '/auth', builder: (context, state) => const AuthPage()),

      // Shell route
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
          GoRoute(
            path: '/verify-code',
            builder: (context, state) => const VerifyCodePage(),
          ),
        ],
      ),
    ],

    redirect: (context, state) async {
      final authService = AuthService();
      final user = authService.currentUser;
      final path = state.uri.path;

      final goingToAuth = path == '/auth';
      final goingToVerify = path == '/verify-code';

      // Not logged in → force AuthPage
      if (user == null && !goingToAuth) return '/auth';

      // Logged in → check verification
      if (user != null) {
        final verified = await authService.isVerified(user.uid);

        // Not verified → force verify-code unless already there or going back to auth
        if (!verified && !goingToVerify && !goingToAuth) return '/verify-code';

        // Verified → skip auth page
        if (verified && goingToAuth) return '/';
      }

      return null;
    },
  );
}
