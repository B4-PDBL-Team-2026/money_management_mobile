import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';

class SendSuccessPage extends StatelessWidget {
  const SendSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing6),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.spacing6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.spacing6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.success10,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppColors.success100,
                    size: 50,
                  ),
                ),
                const SizedBox(height: AppSizes.spacing6),
                Text(
                  "Email Terkirim!",
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: AppSizes.spacing4),
                Text(
                  "Kami telah mengirimkan instruksi pemulihan password ke email Anda. Silakan cek inbox atau folder spam Anda.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSizes.spacing6),
                AppButton(
                  text: "Kembali ke Login",
                  onPressed: () => context.go(AppRouter.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
