import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';

/// A customizable segmented control widget that allows users to select
/// between multiple options.
///
/// Example:
/// ```dart
/// AppSegmentedControl<int>(
///   segments: [
///     SegmentedControlItem(value: 0, label: 'Pengeluaran'),
///     SegmentedControlItem(value: 1, label: 'Pemasukan'),
///   ],
///   selectedValue: _selectedTransactionType,
///   onChanged: (value) {
///     setState(() {
///       _selectedTransactionType = value;
///     });
///   },
/// )
/// ```
class AppSegmentedControl<T> extends StatelessWidget {
  /// The list of segments to display
  final List<SegmentedControlItem<T>> segments;

  /// The currently selected value
  final T selectedValue;

  /// Callback when a segment is selected
  final ValueChanged<T> onChanged;

  /// Background color of the entire control
  final Color? backgroundColor;

  /// Background color of the selected segment
  final Color? selectedColor;

  /// Text color of the selected segment
  final Color? selectedTextColor;

  /// Text color of unselected segments
  final Color? unselectedTextColor;

  /// Border radius of the entire control
  final double? borderRadius;

  /// Border radius of the selected segment
  final double? selectedBorderRadius;

  /// Padding around the entire control
  final EdgeInsetsGeometry? controlPadding;

  /// Padding inside each segment
  final EdgeInsetsGeometry? segmentPadding;

  /// Text size for the segments (in logical pixels)
  final int? textSize;

  /// Height of the control
  final double? height;

  final bool? isDisabled;

  const AppSegmentedControl({
    super.key,
    required this.segments,
    required this.selectedValue,
    required this.onChanged,
    this.backgroundColor,
    this.selectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.borderRadius,
    this.selectedBorderRadius,
    this.controlPadding,
    this.segmentPadding,
    this.textSize,
    this.height,
    this.isDisabled = false,
  }) : assert(segments.length >= 2, 'Must have at least 2 segments'),
       assert(segments.length <= 5, 'Should not have more than 5 segments');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Default values
    final effectiveBackgroundColor = backgroundColor ?? AppColors.lightPrimary;
    final effectiveSelectedColor = selectedColor ?? AppColors.primary;
    final effectiveSelectedTextColor = selectedTextColor ?? AppColors.gohan;
    final effectiveUnselectedTextColor = unselectedTextColor ?? AppColors.bulma;
    final effectiveBorderRadius = borderRadius ?? AppSizes.radiusMd;
    final effectiveSelectedBorderRadius =
        selectedBorderRadius ?? AppSizes.radiusSm;
    final effectiveControlPadding =
        controlPadding ?? const EdgeInsets.all(AppSizes.spacing1);
    final effectiveSegmentPadding =
        segmentPadding ?? const EdgeInsets.all(AppSizes.spacing3);
    final effectiveTextSize = textSize?.toDouble() ?? 12.0;

    return Container(
      height: height,
      padding: effectiveControlPadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
      ),
      child: Row(
        children: segments.map((segment) {
          final isSelected = segment.value == selectedValue;

          // Determine text color for this segment
          final segmentTextColor = isSelected
              ? (segment.selectedTextColor ?? effectiveSelectedTextColor)
              : (segment.unselectedTextColor ?? effectiveUnselectedTextColor);

          // Determine background color for this segment
          final segmentBackgroundColor = isSelected
              ? (segment.selectedBackgroundColor ?? effectiveSelectedColor)
              : (segment.unselectedBackgroundColor ?? Colors.transparent);

          // Create text style with size and color
          final segmentTextStyle = theme.textTheme.bodySmall?.copyWith(
            fontSize: effectiveTextSize,
            fontWeight: FontWeight.w600,
            color: segmentTextColor,
          );

          // Determine icon for this segment
          Widget? segmentIcon;
          if (isSelected && segment.selectedIcon != null) {
            segmentIcon = segment.selectedIcon;
          } else if (!isSelected && segment.unselectedIcon != null) {
            segmentIcon = segment.unselectedIcon;
          } else if (segment.icon != null) {
            segmentIcon = segment.icon;
          }

          return Expanded(
            flex: segment.flex,
            child: GestureDetector(
              onTap: segment.enabled && isDisabled != true
                  ? () {
                      if (!isSelected) {
                        onChanged(segment.value);
                      }
                    }
                  : null,
              child: Container(
                padding: effectiveSegmentPadding,
                decoration: BoxDecoration(
                  color: segmentBackgroundColor,
                  borderRadius: BorderRadius.circular(
                    effectiveSelectedBorderRadius,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (segmentIcon != null) ...[
                      segmentIcon,
                      if (segment.label != null)
                        const SizedBox(width: AppSizes.spacing2),
                    ],
                    if (segment.label != null)
                      Flexible(
                        child: Text(
                          segment.label!,
                          textAlign: TextAlign.center,
                          style: segmentTextStyle,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Represents a single segment in the [AppSegmentedControl]
class SegmentedControlItem<T> {
  /// The value associated with this segment
  final T value;

  /// The label text to display
  final String? label;

  /// Whether this segment is enabled
  final bool enabled;

  /// Flex value for this segment (default is 1)
  final int flex;

  /// Text color for this specific segment when selected (overrides control's selectedTextColor)
  final Color? selectedTextColor;

  /// Text color for this specific segment when unselected (overrides control's unselectedTextColor)
  final Color? unselectedTextColor;

  /// Background color for this specific segment when selected (overrides control's selectedColor)
  final Color? selectedBackgroundColor;

  /// Background color for this specific segment when unselected (defaults to transparent)
  final Color? unselectedBackgroundColor;

  /// Icon widget to display (applies to both states unless overridden)
  final Widget? icon;

  /// Icon widget to display when this segment is selected (overrides icon)
  final Widget? selectedIcon;

  /// Icon widget to display when this segment is unselected (overrides icon)
  final Widget? unselectedIcon;

  const SegmentedControlItem({
    required this.value,
    this.label,
    this.enabled = true,
    this.flex = 1,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.icon,
    this.selectedIcon,
    this.unselectedIcon,
  }) : assert(
         label != null || icon != null,
         'At least one of label or icon must be provided',
       );
}
