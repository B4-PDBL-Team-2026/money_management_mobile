import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_container_card.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/daily_budget_card.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/metric_card.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/real_balance_card.dart';

class DashboardBudgetMetrics extends StatelessWidget {
  const DashboardBudgetMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSafeBalanceCard(context),
        const SizedBox(height: AppSizes.spacing3),
        DailyBudgetCard(),
        const SizedBox(height: AppSizes.spacing3),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: 'Sisa Target',
                value: 'Rp ${CurrencyFormatter.format(9700)}',
              ),
            ),
            const SizedBox(width: AppSizes.spacing3),
            Expanded(
              child: MetricCard(
                title: 'Proyeksi Tabungan',
                value: 'Rp ${CurrencyFormatter.format(500000)}',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spacing3),
        RealBalanceCard(balance: 847000),
      ],
    );
  }

  Widget _buildSafeBalanceCard(BuildContext context) {
    return AppCardContainer(
      backgroundColor: AppColors.gohan,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Saldo aman untuk 8 hari ',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            'Rp ${CurrencyFormatter.format(234000)}',
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
