import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/constants/global_constant.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomCategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onTap;
  final Future<bool?> Function(DismissDirection) confirmDismiss;
  final void Function(DismissDirection)? onDismissed;

  const CustomCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.confirmDismiss,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get corresponding phosphor icon from mapping
    final iconData =
        GlobalConstant.categoryIconsMapping[category.icon] ??
        GlobalConstant.categoryIconsMapping['question']!;

    final isExpense = category.type == TransactionType.expense;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacing3),
      child: Dismissible(
        key: Key('custom_category_${category.id}'),
        direction: DismissDirection.endToStart,
        confirmDismiss: confirmDismiss,
        onDismissed: onDismissed,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppSizes.spacing6),
          decoration: BoxDecoration(
            color: AppColors.danger100,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Hapus',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: AppSizes.spacing2),
              Icon(Icons.delete_outline, color: Colors.white),
            ],
          ),
        ),
        child: AppContainerCard(
          backgroundColor: Colors.white,
          border: Border.all(color: AppColors.beerus, width: 1),
          padding: EdgeInsets.zero,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spacing4),
              child: Row(
                children: [
                  // Icon Container
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isExpense
                          ? AppColors.danger10.withValues(alpha: 0.5)
                          : AppColors.success10.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: Center(
                      child: PhosphorIcon(
                        iconData,
                        color: isExpense
                            ? AppColors.danger100
                            : AppColors.success100,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacing4),

                  // Name and Badges
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.bulma,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacing1),
                        // Type Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.spacing2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isExpense
                                ? AppColors.danger10.withValues(alpha: 0.5)
                                : AppColors.success10.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusSm,
                            ),
                          ),
                          child: Text(
                            isExpense ? 'Pengeluaran' : 'Pemasukan',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isExpense
                                  ? AppColors.danger100
                                  : AppColors.success100,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edit Indicator Chevron
                  Icon(Icons.chevron_right, color: AppColors.trunks, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
