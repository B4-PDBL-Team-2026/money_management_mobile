import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/injection_container.dart';
import 'package:money_management_mobile/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjectionContainer();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Moco',
      routerConfig: AppRouter.router,
      theme: AppTheme.lightTheme,
    );
  }
}
