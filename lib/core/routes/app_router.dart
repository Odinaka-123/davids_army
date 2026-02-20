import 'package:go_router/go_router.dart';
import '../../features/home/home_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/sermons/sermons_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return HomeShell(child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/sermons',
            builder: (context, state) => const SermonsScreen(),
          ),
        ],
      ),
    ],
  );
}
