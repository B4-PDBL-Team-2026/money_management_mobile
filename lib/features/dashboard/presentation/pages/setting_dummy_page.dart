import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';

class SettingsDummyPage extends StatelessWidget {
  const SettingsDummyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.settings, size: 64, color: AppColors.trunks),
              const SizedBox(height: AppSizes.spacing4),
              Text(
                'Pengaturan Anda akan muncul di sini',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.trunks),
              ),
              const SizedBox(height: AppSizes.spacing6),
              AppButton(
                text: 'Keluar',
                onPressed: () => context.read<SessionCubit>().logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
