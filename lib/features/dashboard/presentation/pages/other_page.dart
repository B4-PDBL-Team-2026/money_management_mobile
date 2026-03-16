import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/other_profile_card.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/other_settings_card.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/other_settings_tile.dart';

class OtherPage extends StatelessWidget {
  const OtherPage({super.key});

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
                    title: 'Edit Anggaran & Biaya Tetap',
                    subtitle: 'Ubah uang saku & pengeluaran tetap',
                    iconBackground: AppColors.lightPrimary,
                    iconColor: AppColors.primary,
                    onTap: () {},
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
                  OtherSettingsTile(
                    icon: Icons.lock_outline,
                    title: 'Ganti Password',
                    subtitle: 'Perbarui keamanan akunmu',
                    iconBackground: AppColors.lightPrimary,
                    iconColor: AppColors.primary,
                    onTap: () {},
                  ),
                  Divider(height: 1, thickness: 1, color: AppColors.beerus),
                  OtherSettingsTile(
                    icon: Icons.logout,
                    title: 'Keluar',
                    subtitle: 'Logout dari akun ini',
                    iconBackground: AppColors.danger10,
                    iconColor: AppColors.danger100,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spacing8),
              AppButton(
                text: 'Reset Semua Data Transaksi',
                onPressed: () {},
                variant: AppButtonVariant.ghost,
                type: AppButtonType.danger,
                leadingIcon: Icons.delete_outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
