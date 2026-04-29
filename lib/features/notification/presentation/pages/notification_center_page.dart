import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/relative_time.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:money_management_mobile/features/notification/presentation/cubit/notification_center_cubit.dart';
import 'package:money_management_mobile/features/notification/presentation/cubit/notification_center_state.dart';
import 'package:money_management_mobile/features/notification/presentation/widgets/notification_item_card.dart';
import 'package:money_management_mobile/injection_container.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NotificationCenterPage extends StatefulWidget {
  const NotificationCenterPage({super.key});

  @override
  State<NotificationCenterPage> createState() => _NotificationCenterPageState();
}

class _NotificationCenterPageState extends State<NotificationCenterPage> {
  @override
  void initState() {
    super.initState();
    getIt<NotificationCenterCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gohan,
      body: SafeArea(
        child: BlocBuilder<NotificationCenterCubit, NotificationCenterState>(
          builder: (context, state) {
            if (state is NotificationCenterInitial ||
                state is NotificationCenterLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is NotificationCenterError) {
              return _NotificationCenterErrorState(
                message: state.message,
                onRetry: () {
                  context.read<NotificationCenterCubit>().fetchNotifications(
                    forceRefresh: true,
                  );
                },
              );
            }

            final successState = state as NotificationCenterSuccess;
            final groupedNotifications = _groupNotifications(
              successState.visibleNotifications,
            );

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.spacing6,
                    AppSizes.spacing6,
                    AppSizes.spacing6,
                    AppSizes.spacing8,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifikasi',
                          style: AppTextStyles.h1.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacing5),
                        AppSegmentedControl<NotificationCenterFilter>(
                          segments: const [
                            SegmentedControlItem(
                              value: NotificationCenterFilter.all,
                              label: 'Semua',
                            ),
                            SegmentedControlItem(
                              value: NotificationCenterFilter.unread,
                              label: 'Belum dibaca',
                            ),
                            SegmentedControlItem(
                              value: NotificationCenterFilter.read,
                              label: 'Dibaca',
                            ),
                          ],
                          selectedValue: successState.selectedFilter,
                          onChanged: (filter) {
                            context
                                .read<NotificationCenterCubit>()
                                .changeFilter(filter);
                          },
                          backgroundColor: AppColors.gohan,
                          selectedColor: AppColors.primary,
                          selectedTextColor: AppColors.gohan,
                          unselectedTextColor: AppColors.trunks,
                          borderRadius: AppSizes.radiusXl,
                          selectedBorderRadius: AppSizes.radiusXl,
                          controlPadding: const EdgeInsets.all(
                            AppSizes.spacing1,
                          ),
                          segmentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.spacing4,
                            vertical: AppSizes.spacing2,
                          ),
                          textSize: 13,
                          height: 46,
                        ),
                        const SizedBox(height: AppSizes.spacing6),
                        if (groupedNotifications.isEmpty)
                          const _NotificationCenterEmptyState()
                        else
                          ...groupedNotifications.entries.expand((entry) {
                            final widgets = <Widget>[
                              Text(
                                entry.key,
                                style: AppTextStyles.overline.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: AppSizes.spacing3),
                              AppContainerCard(
                                backgroundColor: AppColors.gohan,
                                padding: EdgeInsets.zero,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radiusMd,
                                  ),
                                  child: Column(
                                    children: [
                                      for (
                                        var index = 0;
                                        index < entry.value.length;
                                        index++
                                      ) ...[
                                        NotificationItemCard(
                                          notificationId: entry.value[index].id,
                                          title: entry.value[index].title,
                                          message: entry.value[index].message,
                                          isRead: entry.value[index].isRead,
                                          onTap: () {
                                            _handleNotificationTap(
                                              context,
                                              entry.value[index],
                                            );
                                          },
                                          onDismissed: () {
                                            context
                                                .read<NotificationCenterCubit>()
                                                .dismissNotification(
                                                  entry.value[index].id,
                                                );
                                          },
                                        ),
                                        if (index < entry.value.length - 1)
                                          const Divider(
                                            height: 1,
                                            thickness: 1,
                                            color: AppColors.beerus,
                                          ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSizes.spacing4),
                            ];

                            return widgets;
                          }),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    NotificationEntity notification,
  ) {
    context.read<NotificationCenterCubit>().markAsRead(notification.id);

    final routePath = notification.notificationCode.routePath;
    if (routePath == null) {
      return;
    }

    context.push(routePath);
  }

  Map<String, List<NotificationEntity>> _groupNotifications(
    List<NotificationEntity> notifications,
  ) {
    final grouped = <String, List<NotificationEntity>>{};

    for (final notification in notifications) {
      final sectionLabel = RelativeTime.formatRelative(notification.createdAt);
      grouped.putIfAbsent(sectionLabel, () => <NotificationEntity>[]);
      grouped[sectionLabel]!.add(notification);
    }

    return grouped;
  }
}

class _NotificationCenterEmptyState extends StatelessWidget {
  const _NotificationCenterEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.spacing12),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.lightPrimary,
                borderRadius: BorderRadius.circular(AppSizes.radius2xl),
              ),
              child: const PhosphorIcon(
                PhosphorIconsRegular.bellSlash,
                color: AppColors.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: AppSizes.spacing4),
            Text(
              'Tidak ada notifikasi',
              style: AppTextStyles.subtitle.copyWith(color: AppColors.bulma),
            ),
            const SizedBox(height: AppSizes.spacing1),
            Text(
              'Coba pilih filter lain atau tunggu notifikasi baru masuk.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMain.copyWith(color: AppColors.trunks),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCenterErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _NotificationCenterErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacing6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMain.copyWith(color: AppColors.bulma),
            ),
            const SizedBox(height: AppSizes.spacing4),
            OutlinedButton(onPressed: onRetry, child: const Text('Muat Ulang')),
          ],
        ),
      ),
    );
  }
}
