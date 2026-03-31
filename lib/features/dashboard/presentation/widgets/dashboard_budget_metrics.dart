import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_container_card.dart';
import 'package:money_management_mobile/features/dashboard/domain/usecases/calculate_dashboard_metrics_usecase.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_state.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/daily_budget_card.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/metric_card.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/real_balance_card.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/calculate_financial_profile_usecase.dart';

class DashboardBudgetMetrics extends StatelessWidget {
  const DashboardBudgetMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.watch<DashboardMetricCubit>().state;

    if (dashboardState is DashboardMetricLoading) {
      return SizedBox(
        height: 400,
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (dashboardState is DashboardMetricLoaded) {
      return _buildMetrics(context, dashboardState.metrics);
    } else if (dashboardState is DashboardMetricError) {
      return SizedBox(
        height: 400,
        child: Center(
          child: Column(
            children: [
              Text('Gagal memuat data dashboard'),
              const SizedBox(height: AppSizes.spacing2),
              AppButton(
                onPressed: () {
                  context.read<DashboardMetricCubit>().fetchDashboardMetrics();
                },
                text: 'Coba Lagi',
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildMetrics(BuildContext context, DashboardMetricsResult metrics) {
    return Column(
      children: [
        if (metrics.healthScenario != BudgetHealthScenario.deficit) ...[
          _buildSafeBalanceCard(
            context,
            metrics.remainingDaysInCycle,
            metrics.safeBalance,
          ),
        ] else ...[
          AppContainerCard(
            backgroundColor: AppColors.danger10,
            border: Border.all(color: AppColors.danger100, width: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Total fixed cost yang belum dibayar',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.danger100,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.spacing2),
                Text(
                  'Rp ${CurrencyFormatter.format(metrics.totalUnpaidFixedCost)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.danger100,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSizes.spacing3),
        if (metrics.balance == 0 ||
            metrics.healthScenario == BudgetHealthScenario.deficit) ...[
          AppContainerCard(
            width: double.infinity,
            height: 150,
            backgroundColor: AppColors.danger100,
            child: Center(
              child: Text(
                'Saldo anda sudah habis',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.gohan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ] else ...[
          DailyBudgetCard(
            dailyExpense: metrics.todaySpent,
            dailyLimit: metrics.limit,
            limitName: metrics.limitName,
            limitState: metrics.limitState,
            healthScenario: metrics.healthScenario,
          ),
          const SizedBox(height: AppSizes.spacing3),
          if (metrics.healthScenario != BudgetHealthScenario.deficit) ...[
            Row(
              children: [
                Expanded(child: MetricCard(metric: metrics.firstMetric)),
                const SizedBox(width: AppSizes.spacing3),
                Expanded(child: MetricCard(metric: metrics.secondMetric)),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(child: MetricCard(metric: metrics.firstMetric)),
                const SizedBox(width: AppSizes.spacing3),
                Expanded(
                  child: MetricCard(
                    metric: metrics.secondMetric,
                    backgroundColor: AppColors.danger10,
                    textColor: AppColors.danger100,
                    boxBorder: Border.all(color: AppColors.danger100, width: 1),
                  ),
                ),
              ],
            ),
          ],
        ],
        const SizedBox(height: AppSizes.spacing3),
        RealBalanceCard(balance: metrics.balance),
      ],
    );
  }

  Widget _buildSafeBalanceCard(
    BuildContext context,
    int remainingDaysInCycle,
    int safeBalance,
  ) {
    return AppContainerCard(
      backgroundColor: AppColors.gohan,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Saldo aman untuk $remainingDaysInCycle hari ',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            'Rp ${CurrencyFormatter.format(safeBalance)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.bulma,
            ),
          ),
        ],
      ),
    );
  }
}
