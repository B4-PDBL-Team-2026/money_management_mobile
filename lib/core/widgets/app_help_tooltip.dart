import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// A reusable help tooltip widget that displays an info icon (ℹ️)
/// which, when tapped, shows a tooltip bubble with a help message.
///
/// The tooltip appears as a blue bubble over a semi-transparent overlay,
/// and can be dismissed by tapping anywhere on the screen.
class AppHelpTooltip extends StatefulWidget {
  /// The help message to display in the tooltip bubble.
  final String message;

  /// An optional child widget to display alongside the info icon.
  /// If provided, the info icon appears after the child.
  final Widget? child;

  /// The size of the info icon. Defaults to 16.
  final double iconSize;

  /// The color of the info icon. Defaults to [AppColors.trunks].
  final Color? iconColor;

  /// Maximum width of the tooltip bubble. Defaults to 260.
  final double maxTooltipWidth;

  const AppHelpTooltip({
    super.key,
    required this.message,
    this.child,
    this.iconSize = 16,
    this.iconColor,
    this.maxTooltipWidth = 260,
  });

  @override
  State<AppHelpTooltip> createState() => _AppHelpTooltipState();
}

class _AppHelpTooltipState extends State<AppHelpTooltip>
    with SingleTickerProviderStateMixin {
  final GlobalKey _iconKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  void _showTooltip() {
    if (_overlayEntry != null) {
      return;
    }

    final renderBox = _iconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return;
    }

    final iconPosition = renderBox.localToGlobal(Offset.zero);
    final iconSize = renderBox.size;
    final overlay = Overlay.of(context);
    final screenSize = MediaQuery.of(context).size;

    // Determine whether the tooltip should appear above or below
    final spaceBelow = screenSize.height - iconPosition.dy - iconSize.height;
    final showAbove = spaceBelow < 180;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                // Semi-transparent overlay backdrop
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _dismissTooltip,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                  ),
                ),

                // Tooltip bubble with arrow
                _TooltipBubble(
                  message: widget.message,
                  iconPosition: iconPosition,
                  iconSize: iconSize,
                  screenSize: screenSize,
                  showAbove: showAbove,
                  maxWidth: widget.maxTooltipWidth,
                  onDismiss: _dismissTooltip,
                ),
              ],
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
    _animationController.forward();
  }

  Future<void> _dismissTooltip() async {
    await _animationController.reverse();
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.child!,
          const SizedBox(width: AppSizes.spacing1),
          GestureDetector(
            key: _iconKey,
            onTap: _showTooltip,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: PhosphorIcon(
                PhosphorIconsFill.info,
                size: widget.iconSize,
                color: widget.iconColor ?? AppColors.trunks,
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      key: _iconKey,
      onTap: _showTooltip,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacing1),
        child: PhosphorIcon(
          PhosphorIconsFill.info,
          size: widget.iconSize,
          color: widget.iconColor ?? AppColors.trunks,
        ),
      ),
    );
  }
}

/// The actual tooltip bubble with arrow pointer.
class _TooltipBubble extends StatelessWidget {
  final String message;
  final Offset iconPosition;
  final Size iconSize;
  final Size screenSize;
  final bool showAbove;
  final double maxWidth;
  final VoidCallback onDismiss;

  static const double _arrowSize = AppSizes.spacing2;
  static const double _horizontalPadding = AppSizes.spacing4;
  static const double _verticalGap = AppSizes.spacing1;

  const _TooltipBubble({
    required this.message,
    required this.iconPosition,
    required this.iconSize,
    required this.screenSize,
    required this.showAbove,
    required this.maxWidth,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate horizontal position — center the bubble on the icon,
    // but clamp to keep within screen bounds.
    final iconCenterX = iconPosition.dx + iconSize.width / 2;
    double left = iconCenterX - maxWidth / 2;
    left = left.clamp(
      _horizontalPadding,
      screenSize.width - maxWidth - _horizontalPadding,
    );

    // Arrow points to the icon center
    final arrowLeft = (iconCenterX - left - _arrowSize).clamp(
      AppSizes.spacing3,
      maxWidth - _arrowSize - AppSizes.spacing3,
    );

    // Calculate vertical position
    double top;
    if (showAbove) {
      top = iconPosition.dy - _verticalGap;
    } else {
      top = iconPosition.dy + iconSize.height + _verticalGap;
    }

    return Positioned(
      left: left,
      top: showAbove ? null : top,
      bottom: showAbove ? screenSize.height - top : null,
      child: GestureDetector(
        onTap: onDismiss,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!showAbove)
              Padding(
                padding: EdgeInsets.only(left: arrowLeft),
                child: CustomPaint(
                  size: const Size(_arrowSize * 2, _arrowSize),
                  painter: _ArrowPainter(pointUp: true),
                ),
              ),
            Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacing4,
                vertical: AppSizes.spacing3,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.bulma.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ),
            if (showAbove)
              Padding(
                padding: EdgeInsets.only(left: arrowLeft),
                child: CustomPaint(
                  size: const Size(_arrowSize * 2, _arrowSize),
                  painter: _ArrowPainter(pointUp: false),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Paints a small triangle arrow for the tooltip bubble.
class _ArrowPainter extends CustomPainter {
  final bool pointUp;

  _ArrowPainter({required this.pointUp});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final path = Path();
    if (pointUp) {
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
