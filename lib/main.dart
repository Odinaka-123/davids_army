import 'package:flutter/material.dart';
import 'core/routes/app_router.dart';

void main() {
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
