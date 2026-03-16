import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
              const _ProfileCard(),
              const SizedBox(height: AppSizes.spacing8),
              Text(
                'KEUANGAN',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.trunks,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSizes.spacing4),
              _SettingsCard(
                children: [
                  _SettingsTile(
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
              _SettingsCard(
                children: [
                  _SettingsTile(
                    icon: Icons.lock_outline,
                    title: 'Ganti Password',
                    subtitle: 'Perbarui keamanan akunmu',
                    iconBackground: AppColors.lightPrimary,
                    iconColor: AppColors.primary,
                    onTap: () {},
                  ),
                  Divider(height: 1, thickness: 1, color: AppColors.beerus),
                  _SettingsTile(
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

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing5,
        vertical: AppSizes.spacing6,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.radiusNm),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightPrimary,
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 54,
                  color: AppColors.mediumPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing4),
          Text(
            'Alexandra',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.gohan,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.spacing1),
          Text(
            'alexandra@gmail.com',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.gohan),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.gohan,
        borderRadius: BorderRadius.circular(AppSizes.radiusNm),
        border: Border.all(color: AppColors.beerus),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconBackground;
  final Color iconColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBackground,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing4),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: PhosphorIcon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: AppSizes.spacing3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.bulma,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing1),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
