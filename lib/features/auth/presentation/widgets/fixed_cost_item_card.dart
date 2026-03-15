import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';

class FixedCostItemCard extends StatelessWidget {
  const FixedCostItemCard({
    super.key,
    required this.name,
    required this.cycle,
    required this.amount,
    required this.isIn,
    this.showDeleteAction = false,
    this.onDelete,
  });

  final String name;
  final String cycle;
  final String amount;
  final bool isIn;
  final bool showDeleteAction;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final statusLabel = isIn ? 'In' : 'Out';
    final statusColor = isIn ? AppColors.primary : AppColors.danger100;

    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.beerus),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing2,
                  vertical: AppSizes.spacing1,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Text(
                  statusLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (showDeleteAction) ...[
                const SizedBox(width: AppSizes.spacing1),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.danger100,
                    size: AppSizes.spacing6,
                  ),
                  onPressed: onDelete,
                  padding: const EdgeInsets.all(AppSizes.spacing1),
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSizes.spacing3),
          Row(
            children: [
              Expanded(
                child: _DetailValue(label: 'Siklus', value: cycle),
              ),
              Expanded(
                child: _DetailValue(
                  label: 'Nominal',
                  value: amount,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailValue extends StatelessWidget {
  const _DetailValue({
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
