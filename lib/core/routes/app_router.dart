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
import '../../features/give/pages/give_page.dart';
import '../../features/prayer/prayer_request_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/auth',

    routes: [
      // 🔓 AUTH ROUTES (NO SHELL)
      GoRoute(path: '/auth', builder: (context, state) => const AuthPage()),
      GoRoute(
        path: '/verify-code',
        builder: (context, state) => const VerifyCodePage(),
      ),

      // 🔐 APP ROUTES (WITH SHELL)
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
          GoRoute(path: '/give', builder: (context, state) => const GivePage()),
          GoRoute(
            path: '/prayer',
            builder: (context, state) => const PrayerRequestPage(),
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
      if (user == null) {
        return goingToAuth ? null : '/auth';
      }

      final email = user.email;
      if (email == null) {
        await authService.signOut();
        return '/auth';
      }

      final verified = await BackendService.isEmailVerified(email);

      // ❌ NOT VERIFIED → FORCE VERIFY PAGE
      if (!verified) {
        return goingToVerify ? null : '/verify-code';
      }

      // ✅ VERIFIED → BLOCK AUTH + VERIFY
      if (verified && (goingToAuth || goingToVerify)) {
        return '/';
      }

      return null;
    },
  );
}
