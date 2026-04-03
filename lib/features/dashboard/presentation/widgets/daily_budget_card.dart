import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/dashboard/domain/usecases/calculate_dashboard_metrics_usecase.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/calculate_financial_profile_usecase.dart';

class DailyBudgetCard extends StatelessWidget {
  final int dailyExpense;
  final int dailyLimit;
  final String limitName;
  final DashboardLimitState limitState;
  final BudgetHealthScenario healthScenario;

  const DailyBudgetCard({
    super.key,
    required this.dailyExpense,
    required this.dailyLimit,
    required this.limitName,
    required this.limitState,
    required this.healthScenario,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengeluaran Hari Ini',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.gohan,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.spacing4),
          Text(
            'Rp ${CurrencyFormatter.format(dailyExpense)}',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: AppColors.gohan,
              fontWeight: FontWeight.bold,
              fontSize: 34,
            ),
          ),
          const SizedBox(height: AppSizes.spacing4),
          AppProgressBar(
            progress: dailyExpense / dailyLimit,
            color: healthScenario == BudgetHealthScenario.deficit
                ? Colors.red
                : _resolveProgressColor(limitState),
          ),
          const SizedBox(height: AppSizes.spacing2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                limitName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.gohan,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Rp ${CurrencyFormatter.format(dailyLimit)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.gohan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _resolveProgressColor(DashboardLimitState limitState) {
    return switch (limitState) {
      DashboardLimitState.underFirstLimit => Colors.green,
      DashboardLimitState.overFirstLimit => Colors.orange,
      DashboardLimitState.overLastLimit => Colors.red,
    };
  }
}
