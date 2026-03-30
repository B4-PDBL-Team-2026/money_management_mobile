import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_confirm_dialog.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/other_profile_card.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/other_settings_card.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/other_settings_tile.dart';

class OtherPage extends StatelessWidget {
  const OtherPage({super.key});

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
                  // OtherSettingsTile(
                  //   icon: Icons.lock_outline,
                  //   title: 'Ganti Password',
                  //   subtitle: 'Perbarui keamanan akunmu',
                  //   iconBackground: AppColors.lightPrimary,
                  //   iconColor: AppColors.primary,
                  //   onTap: () {},
                  // ),
                  Divider(height: 1, thickness: 1, color: AppColors.beerus),
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
