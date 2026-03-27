import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';

class FixedCostItemDetailValue extends StatelessWidget {
  const FixedCostItemDetailValue({
    super.key,
    required this.label,
    required this.value,
    this.textAlign = TextAlign.start,
  });

  final String label;
  final String value;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: textAlign,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
        ),
        const SizedBox(height: AppSizes.spacing1),
        Text(
          value,
          textAlign: textAlign,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
