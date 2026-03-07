import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';

class LoginSuccessPage extends StatelessWidget {
  const LoginSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          padding: const EdgeInsets.all(AppSizes.spacing5),
          decoration: BoxDecoration(
            color: AppColors.beerus,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ikon Centang dalam Lingkaran
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 60,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSizes.spacing5),

              // Teks Notifikasi
              Text(
                'Login Successfull',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSizes.spacing7),

              // Tombol Continue
              SizedBox(
                width: double.infinity,
                height: AppSizes.spacing9,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(AppRouter.dashboard);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.trunks,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
