import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const DavidsArmyApp());
}

class DavidsArmyApp extends StatelessWidget {
  const DavidsArmyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "David's Army",
      theme: ThemeData(useMaterial3: true),
      routerConfig: AppRouter.router,
    );
  }
}
