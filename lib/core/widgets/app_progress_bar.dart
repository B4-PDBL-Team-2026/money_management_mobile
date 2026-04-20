import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';

class AppProgressBar extends StatelessWidget {
  final double height;
  final double progress;
  final Color color;

  const AppProgressBar({
    super.key,
    required this.progress,
    this.height = 10,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final progress = this.progress.isNaN
        ? 0.0
        : this.progress.clamp(0.0, double.infinity);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final labelWidth = progress > 1 ? 50.0 : 37.0;
        final currentProgressWidth = maxWidth * progress;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // label
            SizedBox(
              width: maxWidth,
              height: 20,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    left: (currentProgressWidth - labelWidth / 2).clamp(
                      0,
                      maxWidth - labelWidth,
                    ),
                    child: SizedBox(
                      width: labelWidth,
                      child: Text(
                        '${(progress * 100).toInt()}%',
                        textAlign: progress == 0
                            ? TextAlign.left
                            : progress > 1
                            ? TextAlign.right
                            : TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.gohan,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spacing1),

            // progress bar
            Stack(
              children: [
                // background
                Container(
                  height: height,
                  width: maxWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // progress
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: height,
                  width: currentProgressWidth,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
