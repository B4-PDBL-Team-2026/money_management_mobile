import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/fixed_cost_item_detail_value.dart';

enum FixedCostStatus { paid, pending, overdue, skipped, void_ }

extension FixedCostStatusX on FixedCostStatus {
  String get label {
    return switch (this) {
      FixedCostStatus.paid => 'Lunas',
      FixedCostStatus.pending => 'Pending',
      FixedCostStatus.overdue => 'Terlambat',
      FixedCostStatus.skipped => 'Dilewati',
      FixedCostStatus.void_ => 'Dibatalkan',
    };
  }

  Color get color {
    return switch (this) {
      FixedCostStatus.paid => AppColors.success100,
      FixedCostStatus.pending => AppColors.bulma,
      FixedCostStatus.overdue => AppColors.danger100,
      FixedCostStatus.skipped => AppColors.trunks,
      FixedCostStatus.void_ => AppColors.beerus,
    };
  }

  Color get bgColor {
    return switch (this) {
      FixedCostStatus.paid => const Color(0xFFE8F5E9),
      FixedCostStatus.pending => const Color(0xFFE3F2FD),
      FixedCostStatus.overdue => const Color(0xFFFFEBEE),
      FixedCostStatus.skipped => const Color(0xFFFAFAFA),
      FixedCostStatus.void_ => const Color(0xFFFAFAFA),
    };
  }
}

class ActiveFixedCostItemCard extends StatelessWidget {
  const ActiveFixedCostItemCard({
    super.key,
    required this.name,
    required this.category,
    required this.cycleType,
    required this.dueDate,
    required this.amount,
    required this.status,
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
  final FixedCostStatus status;
  final bool showDeleteAction;
  final bool showEditAction;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: AppSizes.spacing3),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing2,
                  vertical: AppSizes.spacing1,
                ),
                decoration: BoxDecoration(
                  color: status.bgColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Text(
                  status.label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: status.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spacing2),
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
            ],
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
