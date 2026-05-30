import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/google_auth_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/google_auth_state.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GoogleAuthCubit, GoogleAuthState>(
      listener: (context, state) {
        if (state is GoogleAuthSuccess) {
          AppSnackBar.showSuccess(context, "Login berhasil, lanjut yuk!");

          if (state.requiresOnboarding) {
            context.go(AppRouter.step1Personalization);
          } else {
            context.go(AppRouter.dashboard);
          }
        }

        if (state is GoogleAuthError) {
          AppSnackBar.showError(context, state.message);
        }
      },
      child: Scaffold(
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
                        text: 'Masuk',
                        onPressed: () {
                          context.go(AppRouter.login);
                        },
                      ),
                      const SizedBox(height: AppSizes.spacing4),
                      AppButton(
                        text: "Daftar",
                        onPressed: () {
                          context.go(AppRouter.registration);
                        },
                        type: AppButtonType.secondary,
                      ),
                      const SizedBox(height: AppSizes.spacing4),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppColors.trunks.withOpacity(0.3),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.spacing3,
                            ),
                            child: Text(
                              "atau",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.trunks,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.trunks.withOpacity(0.3),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacing4),
                      BlocBuilder<GoogleAuthCubit, GoogleAuthState>(
                        builder: (context, state) {
                          final isLoading = state is GoogleAuthLoading;
                          return Container(
                            width: double.infinity,
                            height: AppSizes.spacing9,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFDADCE0)),
                              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: isLoading
                                  ? null
                                  : () {
                                      context.read<GoogleAuthCubit>().signInWithGoogle();
                                    },
                              borderRadius: BorderRadius.circular(AppSizes.radiusNm),
                              child: Center(
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            AppColors.primary,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svg/google-logo.svg',
                                            height: 20,
                                            width: 20,
                                          ),
                                          const SizedBox(width: AppSizes.spacing3),
                                          const Text(
                                            'Lanjutkan dengan Google',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF3C4043),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
