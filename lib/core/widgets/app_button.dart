import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import '../theme/app_text_styles.dart';

enum AppButtonType { primary, secondary }

enum AppButtonVariant { filled, outlined, ghost }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final AppButtonType type;
  final AppButtonVariant variant;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.type = AppButtonType.primary,
    this.variant = AppButtonVariant.filled,
  });

  bool get _isPrimary => type == AppButtonType.primary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity, // Default penuhi lebar layar
      height: AppSizes.spacing9,
      child: ElevatedButton(
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (variant == AppButtonVariant.filled) {
              return _isPrimary ? AppColors.primary : AppColors.secondary;
            } else if (variant == AppButtonVariant.outlined) {
              return AppColors.gohan;
            } else {
              return _isPrimary
                  ? AppColors.lightPrimary
                  : AppColors.lightSecondary;
            }
          }),
          side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
            if (variant == AppButtonVariant.outlined) {
              return BorderSide(
                color: _isPrimary ? AppColors.primary : AppColors.secondary,
                width: 1,
              );
            }

            return null;
          }),
          shadowColor: WidgetStateProperty.all(
            variant == AppButtonVariant.filled
                ? Colors.transparent
                : Colors.black.withValues(alpha: 0.1),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: variant == AppButtonVariant.filled
                      ? AppColors.gohan
                      : (_isPrimary ? AppColors.primary : AppColors.secondary),
                ),
              )
            : Text(
                text,
                style: AppTextStyles.subtitle.copyWith(
                  color: variant == AppButtonVariant.filled
                      ? AppColors.gohan
                      : (_isPrimary ? AppColors.primary : AppColors.secondary),
                ), // Terkunci di standar kamu
              ),
      ),
    );
  }
}
