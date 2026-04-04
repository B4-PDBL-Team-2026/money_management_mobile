import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/dashboard/domain/usecases/calculate_dashboard_metrics_usecase.dart';

class MetricCard extends StatelessWidget {
  final DashboardMetric metric;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final BoxBorder? boxBorder;

  const MetricCard({
    super.key,
    required this.metric,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.boxBorder,
  });

  @override
  Widget build(BuildContext context) {
    if (metric.type == MetricType.blocked) {
      return AppContainerCard(
        height: 85,
        backgroundColor: backgroundColor ?? AppColors.danger100,
        child: Center(
          child: Text(
            metric.name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: textColor ?? AppColors.gohan,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    final value = metric.type == MetricType.currency
        ? 'Rp ${CurrencyFormatter.format(metric.value)}'
        : metric.value > 1
        ? '${metric.value} Hari'
        : 'Hari Ini';

    return AppContainerCard(
      width: width,
      border: boxBorder,
      height: 85,
      backgroundColor: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor ?? AppColors.gohan,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.spacing2),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: textColor ?? AppColors.gohan,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
