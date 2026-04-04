import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  const SummaryCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return AppContainerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.gohan,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.spacing2),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.gohan,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
