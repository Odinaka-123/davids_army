import 'package:go_router/go_router.dart';
import '../../features/auth/auth_page.dart';
import '../../features/home/home_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/sermons/sermons_screen.dart';
import '../../features/settings/profile_page.dart';
import '../../features/settings/edit_profile_page.dart';
import '../../features/auth/verify_code_page.dart';
import '../../features/auth/auth_service.dart';
import '../services/backend_service.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/auth',

    routes: [
      GoRoute(path: '/auth', builder: (context, state) => const AuthPage()),

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

      // 🚫 NOT LOGGED IN
      if (user == null && !goingToAuth) {
        return '/auth';
      }

      // ✅ LOGGED IN → CHECK BACKEND VERIFICATION
      if (user != null) {
        final email = user.email;

        // Safety check
        if (email == null) return '/auth';

        final verified = await BackendService.isEmailVerified(email);

        // ❌ NOT VERIFIED
        if (!verified && !goingToVerify && !goingToAuth) {
          return '/verify-code';
        }

        // ✅ VERIFIED → BLOCK AUTH PAGE
        if (verified && goingToAuth) {
          return '/';
        }
      }

      return null;
    },
  );
}
