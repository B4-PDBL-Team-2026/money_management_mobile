import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NotificationItemCard extends StatelessWidget {
  const NotificationItemCard({
    super.key,
    required this.notificationId,
    required this.title,
    required this.message,
    required this.onDismissed,
    this.onTap,
    this.icon,
    this.isRead = false,
  });

  final String notificationId;
  final String title;
  final String message;
  final VoidCallback? onTap;
  final IconData? icon;
  final VoidCallback onDismissed;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<String>(notificationId),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.danger10,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing5),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PhosphorIcon(
              PhosphorIconsRegular.trash,
              color: AppColors.danger100,
              size: 28,
            ),
            SizedBox(height: AppSizes.spacing1),
            Text(
              'Hapus',
              style: TextStyle(
                color: AppColors.danger100,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDismissed(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          color: backgroundColor,
          padding: const EdgeInsets.all(AppSizes.spacing4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: iconBorderColor, width: 1),
                ),
                child: PhosphorIcon(
                  icon ?? defaultIcon,
                  color: iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSizes.spacing3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMain.copyWith(
                        color: AppColors.bulma,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing1),
                    Text(
                      message,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.trunks,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isRead) ...[
                const SizedBox(width: AppSizes.spacing2),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: AppSizes.spacing1),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color get backgroundColor => isRead ? Colors.white : AppColors.lightPrimary;
  Color get iconBackgroundColor => AppColors.lightSecondary;
  Color get iconColor => AppColors.secondary;
  Color get iconBorderColor => AppColors.secondary;
  IconData get defaultIcon =>
      isRead ? PhosphorIconsRegular.bell : PhosphorIconsRegular.bellRinging;
}
