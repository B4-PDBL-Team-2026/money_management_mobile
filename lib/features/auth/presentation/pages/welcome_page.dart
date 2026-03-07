import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacing8,
            vertical: AppSizes.spacing5,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.spacing10),

              // --- PERUBAHAN LOGO: Menggunakan Image.asset ---
              Image.asset(
                'assets/images/Logo.png',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: AppSizes.spacing8),
              Text(
                "Master your money.\nControl your future.",
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.trunks),
              ),

              const Spacer(),

              // --- TOMBOL   REGISTER (Warna: FFA62B) ---
              _buildButton(
                context,
                "Register",
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.onSecondary,
                () {
                  context.go(AppRouter.registration);
                },
              ),

              const SizedBox(height: AppSizes.spacing4),

              // --- TOMBOL LOGIN (Warna: 2E5AA7) ---
              _buildButton(
                context,
                "Login",
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.onPrimary,
                () {
                  context.go(AppRouter.login);
                },
              ),

              const SizedBox(height: AppSizes.spacing5),
              Text(
                "By continuing you agree to our Terms of Service",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.trunks,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi tombol yang dimodifikasi untuk menerima warna custom
  Widget _buildButton(
    BuildContext context,
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.spacing9,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: textColor),
        ),
      ),
    );
  }
}
