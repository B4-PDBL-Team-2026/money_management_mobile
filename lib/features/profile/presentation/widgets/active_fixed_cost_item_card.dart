import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/fixed_cost_item_detail_value.dart';

class ActiveFixedCostItemCard extends StatelessWidget {
  const ActiveFixedCostItemCard({
    super.key,
    required this.name,
    required this.category,
    required this.cycleType,
    required this.dueDate,
    required this.amount,
    this.showDeleteAction = false,
    this.onDelete,
    this.showEditAction = false,
    this.onEdit,
  });

  final String name;
  final String category;
  final String cycleType;
  final String dueDate;
  final String amount;
  final bool showDeleteAction;
  final bool showEditAction;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing4),
      decoration: BoxDecoration(
        color: Colors.white,
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
              if (showEditAction) ...[
                const SizedBox(width: AppSizes.spacing1),
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.primary,
                    size: AppSizes.spacing6,
                  ),
                  onPressed: onEdit,
                  padding: const EdgeInsets.all(AppSizes.spacing1),
                  constraints: const BoxConstraints(),
                ),
              ],
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
          const SizedBox(width: AppSizes.spacing3),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing2,
              vertical: AppSizes.spacing1,
            ),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Text(
              category,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spacing3),
          Row(
            children: [
              Expanded(
                child: FixedCostItemDetailValue(
                  label: 'Siklus',
                  value: cycleType,
                ),
              ),
              Expanded(
                child: FixedCostItemDetailValue(
                  label: 'Jatuh Tempo',
                  value: dueDate,
                ),
              ),
              Expanded(
                child: FixedCostItemDetailValue(
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
