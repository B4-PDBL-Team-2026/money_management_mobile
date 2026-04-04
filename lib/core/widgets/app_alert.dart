import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';

class AppAlert extends StatelessWidget {
  final String message;
  final List<String>? messages;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;

  const AppAlert({
    super.key,
    this.message = '',
    this.messages,
    this.padding,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? const EdgeInsets.all(AppSizes.spacing4);
    final effectiveIconSize = iconSize ?? 18.0;

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: AppColors.lightPrimary,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primary,
            size: effectiveIconSize,
          ),
          SizedBox(width: effectivePadding.horizontal / 2),
          Expanded(
            child: messages != null && messages!.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSizes.spacing2,
                    children: messages!
                        .map(
                          (msg) => Text(
                            msg,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        )
                        .toList(),
                  )
                : Text(
                    message,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
