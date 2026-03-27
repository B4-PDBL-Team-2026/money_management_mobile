import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/calculate_financial_profile_usecase.dart';

class BudgetHealthBadge extends StatelessWidget {
  final BudgetHealthScenario status;

  const BudgetHealthBadge({
    super.key,
    this.status = BudgetHealthScenario.surplus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spacing2,
        vertical: AppSizes.spacing2,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(status),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Text(
        status.value,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppColors.gohan,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getBackgroundColor(BudgetHealthScenario status) {
    return switch (status) {
      BudgetHealthScenario.surplus => AppColors.success100,
      BudgetHealthScenario.moderate => AppColors.primary,
      BudgetHealthScenario.critical => AppColors.warning100,
      BudgetHealthScenario.deficit => AppColors.danger100,
    };
  }
}
