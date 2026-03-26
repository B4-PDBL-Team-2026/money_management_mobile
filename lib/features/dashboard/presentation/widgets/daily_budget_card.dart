import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_container_card.dart';
import 'package:money_management_mobile/core/widgets/app_progress_bar.dart';

class DailyBudgetCard extends StatelessWidget {
  const DailyBudgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCardContainer(
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
            'Rp ${CurrencyFormatter.format(32000)}',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: AppColors.gohan,
              fontWeight: FontWeight.bold,
              fontSize: 34,
            ),
          ),
          const SizedBox(height: AppSizes.spacing4),
          AppProgressBar(progress: 0.75, color: Colors.green),
          const SizedBox(height: AppSizes.spacing2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Batas optimal',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.gohan,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Rp ${CurrencyFormatter.format(50000)}',
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
}
