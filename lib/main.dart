import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/injection_container.dart';

import 'pages/onboarding.dart'; // Import file yang baru diganti namanya

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjectionContainer();
  runApp(const MyApp());
}

/* backward compatibility, jangan di hapus */
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const OnboardingPage(), // Panggil class yang ada di onboarding.dart
//     );
//   }
// }

/* initialization dengan standar baru, jangan di hapus */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Moco',
      routerConfig: AppRouter.router,
    );
  }
}
