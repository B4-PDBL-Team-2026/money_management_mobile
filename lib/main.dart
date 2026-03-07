import 'package:flutter/material.dart';
import 'package:money_management_mobile/pages/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          OnboardingPage(), // Nama ini harus SAMA persis dengan di file onboarding.dart
    );
  }
}
