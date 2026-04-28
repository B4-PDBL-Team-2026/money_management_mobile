import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/relative_time.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:money_management_mobile/features/notification/presentation/widgets/notification_item_card.dart';

enum NotificationFilter { all, unread, read }

class NotificationCenterPage extends StatefulWidget {
  const NotificationCenterPage({super.key});

  @override
  State<NotificationCenterPage> createState() => _NotificationCenterPageState();
}

class _NotificationCenterPageState extends State<NotificationCenterPage> {
  NotificationFilter _selectedFilter = NotificationFilter.all;

  final List<NotificationEntity> _notifications = [
    NotificationEntity(
      id: 'today-budget-alert',
      createdAt: DateTime(2026, 4, 28),
      title: 'Anggaran Hampir Habis!',
      message:
          'Sisa anggaran harian kamu tinggal Rp 5000. Kurangi pengeluaran hari ini ya!',
      isRead: false,
    ),
    NotificationEntity(
      id: 'yesterday-budget-limit',
      createdAt: DateTime(2026, 4, 28),
      title: 'Batas Anggaran Terlampaui',
      message:
          'Kamu sudah melewati anggaran harian! Total pengeluaranmu hari ini Rp 9000 dari batas Rp 5000',
      isRead: false,
    ),
    NotificationEntity(
      id: 'yesterday-record-expense',
      createdAt: DateTime(2026, 4, 27),
      title: 'Jangan Lupa Catat Pengeluaran',
      message:
          'Kamu belum mencatat transaksi hari ini. Yuk mulai catat biar keuanganmu terkontrol',
      isRead: false,
    ),
    NotificationEntity(
      id: 'budget-tip',
      createdAt: DateTime(2026, 4, 27),
      title: 'Tips Hemat Minggu Ini',
      message:
          'Coba batasi pengeluaran makan di luar maksimal 3x seminggu. Masak sendiri lebih hemat!',
      isRead: true,
    ),
    NotificationEntity(
      id: 'netflix-due',
      createdAt: DateTime(2026, 4, 26),
      title: 'Jatuh Tempo - Netflix',
      message:
          'Netflix Rp 40.000 jatuh tempo hari ini. Pilih tindakan sekarang.',
      isRead: true,
    ),
    NotificationEntity(
      id: 'february-recap',
      createdAt: DateTime(2026, 4, 26),
      title: 'Rekap Bulan Februari',
      message:
          'Selamat! Bulan Februari kamu berhasil menghemat Rp 860.000 dari target. Pertahankan di Maret!',
      isRead: true,
    ),
    NotificationEntity(
      id: 'motor-due',
      createdAt: DateTime(2026, 4, 26),
      title: 'Jatuh Tempo - Cicilan Motor',
      message:
          'Cicilan motor Rp 245.000 jatuh tempo hari ini. Pilih tindakan sekarang.',
      isRead: true,
    ),
    NotificationEntity(
      id: 'february-spending',
      createdAt: DateTime(2026, 4, 25),
      title: 'Jangan Lupa Catat Pengeluaran',
      message:
          'Kamu belum mencatat transaksi hari ini. Yuk mulai catat biar keuanganmu terkontrol',
      isRead: true,
    ),
  ];

  List<NotificationEntity> get _visibleNotifications {
    switch (_selectedFilter) {
      case NotificationFilter.unread:
        return _notifications
            .where((notification) => !notification.isRead)
            .toList();
      case NotificationFilter.read:
        return _notifications
            .where((notification) => notification.isRead)
            .toList();
      case NotificationFilter.all:
        return List<NotificationEntity>.from(_notifications);
    }
  }

  Map<String, List<NotificationEntity>> get _groupedNotifications {
    final Map<String, List<NotificationEntity>> grouped =
        <String, List<NotificationEntity>>{};

    for (final notification in _visibleNotifications) {
      final sectionLabel = RelativeTime.formatRelative(notification.createdAt);

      grouped.putIfAbsent(sectionLabel, () => <NotificationEntity>[]);
      grouped[sectionLabel]!.add(notification);
    }

    return grouped;
  }

  void _removeNotification(String notificationId) {
    setState(() {
      _notifications.removeWhere(
        (notification) => notification.id == notificationId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotifications = _groupedNotifications;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spacing6,
                AppSizes.spacing6,
                AppSizes.spacing6,
                AppSizes.spacing8,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                    AppSegmentedControl<NotificationFilter>(
                      segments: const [
                        SegmentedControlItem(
                          value: NotificationFilter.all,
                          label: 'Semua',
                        ),
                        SegmentedControlItem(
                          value: NotificationFilter.unread,
                          label: 'Belum dibaca',
                        ),
                        SegmentedControlItem(
                          value: NotificationFilter.read,
                          label: 'Dibaca',
                        ),
                      ],
                      selectedValue: _selectedFilter,
                      onChanged: (filter) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      backgroundColor: AppColors.gohan,
                      selectedColor: AppColors.primary,
                      selectedTextColor: AppColors.gohan,
                      unselectedTextColor: AppColors.trunks,
                      borderRadius: AppSizes.radiusXl,
                      selectedBorderRadius: AppSizes.radiusXl,
                      controlPadding: const EdgeInsets.all(AppSizes.spacing1),
                      segmentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spacing4,
                        vertical: AppSizes.spacing2,
                      ),
                      textSize: 13,
                      height: 46,
                    ),
                    const SizedBox(height: AppSizes.spacing6),
                    if (groupedNotifications.isEmpty)
                      Padding(
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
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radius2xl,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: AppColors.primary,
                                  size: 36,
                                ),
                              ),
                              const SizedBox(height: AppSizes.spacing4),
                              Text(
                                'Tidak ada notifikasi',
                                style: AppTextStyles.subtitle.copyWith(
                                  color: AppColors.bulma,
                                ),
                              ),
                              const SizedBox(height: AppSizes.spacing1),
                              Text(
                                'Coba pilih filter lain atau tunggu notifikasi baru masuk.',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyMain.copyWith(
                                  color: AppColors.trunks,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
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
                                      icon: Icons.notifications_rounded,
                                      title: entry.value[index].title,
                                      message: entry.value[index].message,
                                      isRead: entry.value[index].isRead,
                                      onDismissed: () {
                                        _removeNotification(
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
        ),
      ),
    );
  }
}
