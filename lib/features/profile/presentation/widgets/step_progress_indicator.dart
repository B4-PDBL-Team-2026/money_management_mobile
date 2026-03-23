import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: currentStep / totalSteps,
          backgroundColor: AppColors.beerus,
          color: AppColors.secondary,
          minHeight: 8,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        const SizedBox(height: AppSizes.spacing3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Langkah $currentStep',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Langkah $totalSteps',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.trunks,
              ),
            ),
          ],
        ),
      ],
    );
  }
}