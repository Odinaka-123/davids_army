import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/routes/app_router.dart';
import 'core/theme_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/services/push_notification_service.dart';
import 'features/notifications/notification_popup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await PushNotificationService.init();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const DavidsArmyApp());
}

class DavidsArmyApp extends StatelessWidget {
  const DavidsArmyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: "David's Army",

          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,

          routerConfig: AppRouter.router,

          // ✅ THIS IS THE CORRECT PLACE
          builder: (context, child) {
            return Stack(
              children: [
                Scaffold(extendBody: true, body: child),

                // 🔥 NOW SAFE (has Directionality)
                const NotificationPopup(),
              ],
            );
          },
        );
      },
    );
  }
}
