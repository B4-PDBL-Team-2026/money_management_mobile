import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';

import '../theme/app_text_styles.dart';

enum AppButtonType { primary, secondary, danger }

enum AppButtonVariant { filled, outlined, ghost }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final AppButtonType type;
  final AppButtonVariant variant;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double iconSize;
  final double? fontSize;
  final bool? overflow;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.type = AppButtonType.primary,
    this.variant = AppButtonVariant.filled,
    this.leadingIcon,
    this.trailingIcon,
    this.iconSize = 18,
    this.fontSize,
    this.overflow,
  });

  Color get _backgroundColor {
    return switch (variant) {
      AppButtonVariant.filled => switch (type) {
        AppButtonType.primary => AppColors.primary,
        AppButtonType.secondary => AppColors.secondary,
        AppButtonType.danger => AppColors.danger100,
      },
      AppButtonVariant.outlined => AppColors.gohan,
      AppButtonVariant.ghost => switch (type) {
        AppButtonType.primary => AppColors.lightPrimary,
        AppButtonType.secondary => AppColors.lightSecondary,
        AppButtonType.danger => AppColors.danger10,
      },
    };
  }

  Color get _foregroundColor {
    return switch (variant) {
      AppButtonVariant.filled => AppColors.gohan,
      _ => switch (type) {
        AppButtonType.primary => AppColors.primary,
        AppButtonType.secondary => AppColors.secondary,
        AppButtonType.danger => AppColors.danger100,
      },
    };
  }

  Color? get _borderColor {
    if (variant != AppButtonVariant.outlined) return null;
    return switch (type) {
      AppButtonType.primary => AppColors.primary,
      AppButtonType.secondary => AppColors.secondary,
      AppButtonType.danger => AppColors.danger100,
    };
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyles.subtitle.copyWith(
      color: _foregroundColor,
      fontSize: fontSize,
    );

    return SizedBox(
      width: width ?? double.infinity,
      height: AppSizes.spacing9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundColor,
          foregroundColor: _foregroundColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          side: _borderColor != null
              ? BorderSide(color: _borderColor!, width: 1)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.spacing4,
            vertical: AppSizes.spacing3,
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _foregroundColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: iconSize, color: _foregroundColor),
                    const SizedBox(width: AppSizes.spacing2),
                  ],

                  if (overflow == true)
                    Expanded(
                      child: Text(
                        text,
                        style: textStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  else
                    Text(
                      text,
                      style: textStyle,
                      overflow: TextOverflow.ellipsis,
                    ),

                  if (trailingIcon != null) ...[
                    const SizedBox(width: AppSizes.spacing2),
                    Icon(trailingIcon, size: iconSize, color: _foregroundColor),
                  ],
                ],
              ),
      ),
    );
  }
}
