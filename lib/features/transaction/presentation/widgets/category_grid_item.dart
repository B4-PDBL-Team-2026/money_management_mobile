import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({
    super.key,
    required this.categoryName,
    required this.categoryIcon,
    required this.isSelected,
    required this.onTap,
  });

  final String categoryName;
  final IconData categoryIcon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.spacing3),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.lightPrimary,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: PhosphorIcon(
              categoryIcon,
              color: isSelected ? AppColors.gohan : AppColors.trunks,
              size: AppSizes.spacing6,
            ),
          ),
          const SizedBox(height: AppSizes.spacing2),
          Text(
            categoryName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isSelected ? AppColors.primary : AppColors.trunks,
            ),
          ),
        ],
      ),
    );
  }
}
