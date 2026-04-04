import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/reset_password_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/reset_password_state.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_state.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/verify_email_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/verify_email_state.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/other_profile_card.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/other_settings_card.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/other_settings_tile.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OtherPage extends StatelessWidget {
  const OtherPage({super.key});

  Future<void> _onChangePasswordTap(BuildContext context) async {
    final sessionState = context.read<SessionCubit>().state;

    if (sessionState is! SessionAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesi tidak valid. Silakan login ulang.'),
          backgroundColor: AppColors.danger100,
        ),
      );
      return;
    }

    await context.read<ResetPasswordCubit>().sendVerificationEmail(
      email: sessionState.user.email,
    );
  }

  Future<void> _onVerifyEmailTap(BuildContext context) async {
    final sessionState = context.read<SessionCubit>().state;

    if (sessionState is! SessionAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesi tidak valid. Silakan login ulang.'),
          backgroundColor: AppColors.danger100,
        ),
      );
      return;
    }

    if (sessionState.user.emailVerifiedAt != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email Anda sudah terverifikasi.'),
          backgroundColor: AppColors.success100,
        ),
      );
      return;
    }

    await context.read<VerifyEmailCubit>().requestVerificationEmail();
  }

  void _showLoadingDialog(BuildContext context, {required String message}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              ),
              SizedBox(width: AppSizes.spacing4),
              Expanded(child: Text(message)),
            ],
          ),
        );
      },
    );
  }

  void _closeDialogIfOpen(BuildContext context) {
    final rootNavigator = Navigator.of(context, rootNavigator: true);
    if (rootNavigator.canPop()) {
      rootNavigator.pop();
    }
  }

  Future<void> _showSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    await AppConfirmDialog.show(
      context: context,
      title: title,
      content: '$message\n\nSilakan cek inbox atau folder spam Anda.',
      confirmText: 'Mengerti',
      cancelText: 'Tutup',
      confirmButtonType: AppButtonType.primary,
    );
  }

  Future<void> _onLogoutTap(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context: context,
      title: 'Keluar dari akun?',
      content: 'Sesi login akan dihapus dari perangkat ini.',
      confirmText: 'Keluar',
      cancelText: 'Batal',
      confirmButtonType: AppButtonType.danger,
    );

    if (!confirmed || !context.mounted) {
      return;
    }

    try {
      await context.read<CategoryCubit>().clearCategories();

      if (context.mounted) {
        await context.read<SessionCubit>().logout();
      }
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.danger100,
          content: const Text(
            'Gagal logout. Coba lagi.',
            style: TextStyle(color: AppColors.gohan),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gohan,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spacing6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profil & Pengaturan',
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppSizes.spacing6),
              const OtherProfileCard(),
              const SizedBox(height: AppSizes.spacing8),
              Text(
                'KEUANGAN',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.trunks,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSizes.spacing4),
              OtherSettingsCard(
                children: [
                  OtherSettingsTile(
                    icon: Icons.edit_outlined,
                    title: 'Managemen Fixed Cost',
                    subtitle: 'Atur pengeluaran tetap anda',
                    iconBackground: AppColors.lightPrimary,
                    iconColor: AppColors.primary,
                    onTap: () {
                      context.go(AppRouter.fixedCostsManagement);
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spacing6),
              Text(
                'AKUN',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.trunks,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSizes.spacing4),
              OtherSettingsCard(
                children: [
                  BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                    listener: (context, state) async {
                      if (state is ResetPasswordLoading) {
                        _showLoadingDialog(
                          context,
                          message: 'Mengirim email reset password...',
                        );
                        return;
                      }

                      if (state is ResetPasswordSuccess) {
                        _closeDialogIfOpen(context);
                        await _showSuccessDialog(
                          context,
                          title: 'Reset Password Terkirim',
                          message:
                              'Email reset password telah dikirim. Silakan cek inbox atau folder spam Anda.',
                        );
                        return;
                      }

                      if (state is ResetPasswordError) {
                        _closeDialogIfOpen(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.danger100,
                            content: Text(
                              state.message,
                              style: const TextStyle(color: AppColors.gohan),
                            ),
                          ),
                        );
                      }
                    },
                    builder: (context, state) => Column(
                      children: [
                        OtherSettingsTile(
                          icon: Icons.lock_outline,
                          title: 'Ganti Password',
                          subtitle: 'Perbarui keamanan akunmu',
                          iconBackground: AppColors.lightPrimary,
                          iconColor: AppColors.primary,
                          onTap: () => _onChangePasswordTap(context),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.beerus,
                        ),
                      ],
                    ),
                  ),
                  BlocConsumer<VerifyEmailCubit, VerifyEmailState>(
                    listener: (context, state) async {
                      if (state is VerifyEmailLoading) {
                        _showLoadingDialog(
                          context,
                          message: 'Mengirim email verifikasi...',
                        );
                        return;
                      }

                      if (state is VerifyEmailSuccess) {
                        _closeDialogIfOpen(context);
                        await _showSuccessDialog(
                          context,
                          title: 'Verifikasi Email Terkirim',
                          message:
                              'Email verifikasi telah dikirim. Silakan cek inbox atau folder spam Anda.',
                        );
                        return;
                      }

                      if (state is VerifyEmailError) {
                        _closeDialogIfOpen(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.danger100,
                            content: Text(
                              state.message,
                              style: const TextStyle(color: AppColors.gohan),
                            ),
                          ),
                        );
                      }
                    },
                    builder: (context, _) {
                      final sessionState = context.watch<SessionCubit>().state;
                      final isVerified =
                          sessionState is SessionAuthenticated &&
                          sessionState.user.emailVerifiedAt != null;

                      if (isVerified) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          OtherSettingsTile(
                            icon: Icons.email_outlined,
                            title: 'Verifikasi Email',
                            subtitle:
                                'Tingkatkan keamanan akun dengan verifikasi email',
                            iconBackground: AppColors.lightPrimary,
                            iconColor: AppColors.primary,
                            onTap: () => _onVerifyEmailTap(context),
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.beerus,
                          ),
                        ],
                      );
                    },
                  ),
                  OtherSettingsTile(
                    icon: PhosphorIconsRegular.userMinus,
                    title: 'Hapus Akun',
                    subtitle: 'Hapus akun ini secara permanen',
                    iconBackground: AppColors.danger10,
                    iconColor: AppColors.danger100,
                    onTap: () => context.go(AppRouter.deleteAccount),
                  ),
                  OtherSettingsTile(
                    icon: Icons.logout,
                    title: 'Keluar',
                    subtitle: 'Logout dari akun ini',
                    iconBackground: AppColors.danger10,
                    iconColor: AppColors.danger100,
                    onTap: () => _onLogoutTap(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
