import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.spacing6),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/full-logo.svg',
                      height: 65,
                      width: double.infinity,
                    ),
                    const SizedBox(height: AppSizes.spacing12),
                    Text(
                      "Kuasai Keuanganmu dengan Moco",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                    Text(
                      "Atur jatah harian, catat pengeluaran, dan capai tujuan finansialmu dengan mudah.",
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
                    ),
                    const SizedBox(height: AppSizes.spacing12),
                    AppButton(
                      text: 'Login',
                      onPressed: () {
                        context.go(AppRouter.login);
                      },
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                    AppButton(
                      text: "Register",
                      onPressed: () {
                        context.go(AppRouter.registration);
                      },
                      type: AppButtonType.secondary,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
