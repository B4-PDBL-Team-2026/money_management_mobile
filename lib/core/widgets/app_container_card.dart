import 'package:flutter/widgets.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';

class AppCardContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;

  const AppCardContainer({
    super.key,
    required this.child,
    this.border,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(AppSizes.spacing4),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: border ?? Border.all(color: AppColors.beerus, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.beerus.withValues(alpha: 0.7),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
