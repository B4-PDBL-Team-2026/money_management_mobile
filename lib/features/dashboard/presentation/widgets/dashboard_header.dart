import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_state.dart';
import 'package:money_management_mobile/features/dashboard/domain/usecases/calculate_dashboard_metrics_usecase.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_state.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/financial_health_badge.dart';
import 'package:money_management_mobile/features/notification/presentation/cubit/notification_center_cubit.dart';
import 'package:money_management_mobile/features/notification/presentation/cubit/notification_center_state.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/calculate_financial_profile_usecase.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionState = context.read<SessionCubit>().state;
    final username = sessionState is SessionAuthenticated
        ? _resolveUsername(sessionState.user.name)
        : 'Guest';

    final dashboardState = context.watch<DashboardMetricCubit>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Hai, $username!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            if (dashboardState is DashboardMetricLoaded) ...[
              const Spacer(),
              BudgetHealthBadge(status: dashboardState.metrics.healthScenario),
              const SizedBox(width: AppSizes.spacing4),
              _buildNotificationButton(context),
            ],
          ],
        ),
        const SizedBox(height: AppSizes.spacing2),
        if (dashboardState is DashboardMetricLoaded) ...[
          Text(
            _resolveMessage(
              dashboardState.metrics.healthScenario,
              dashboardState.metrics.limitState,
              dashboardState.metrics.balance,
              dashboardState.metrics.totalUnpaidFixedCost,
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ] else if (dashboardState is DashboardMetricLoading) ...[
          Text(
            'Lagi muat data dashboard...',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ] else ...[
          Text(
            'Data dashboard belum bisa dimuat nih',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return BlocBuilder<NotificationCenterCubit, NotificationCenterState>(
      builder: (context, notificationState) {
        final hasUnreadNotifications =
            notificationState is NotificationCenterSuccess &&
            notificationState.allNotifications.any((n) => !n.isRead);

        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                context.go(AppRouter.notification);
              },
              child: Container(
                padding: const EdgeInsets.all(AppSizes.spacing2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: PhosphorIcon(
                  PhosphorIconsRegular.bell,
                  size: 28,
                  color: AppColors.primary,
                ),
              ),
            ),
            if (hasUnreadNotifications)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.danger100,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  String _resolveMessage(
    BudgetHealthScenario scenario,
    DashboardLimitState limitState,
    int balance,
    int totalUnpaidFixedCost,
  ) {
    if (scenario == BudgetHealthScenario.surplus) {
      if (limitState == DashboardLimitState.underFirstLimit) {
        return 'Lagi di jalur hemat! Pertahankan biar tabungan makin aman.';
      } else if (limitState == DashboardLimitState.overFirstLimit) {
        return 'Limit optimalnya kelewatan! Jatah tabungan bakal berkurang kalau transaksi makin banyak.';
      } else {
        return 'Kelewatan batas nih, jatah harian aktual besok bakal berkurang!';
      }
    }

    if (scenario == BudgetHealthScenario.moderate) {
      if (limitState == DashboardLimitState.underFirstLimit ||
          limitState == DashboardLimitState.overFirstLimit) {
        return 'Kondisinya aman. Jaga pengeluaran tetap di bawah batas harian aktual ya.';
      } else {
        return 'Batas harian aktualnya udah kelewatan, mending stop belanja dulu hari ini!';
      }
    }

    if (scenario == BudgetHealthScenario.critical) {
      if (limitState == DashboardLimitState.underFirstLimit) {
        return 'Saldo lagi mepet banget! Tetap di mode Hemat Ekstrem biar cukup sampai akhir bulan.';
      } else if (limitState == DashboardLimitState.overFirstLimit) {
        return 'Mode Hemat Ekstremnya kelewatan. Sekarang kamu pakai jatah “Bertahan Hidup”.';
      } else {
        return 'Batas harian aktualnya udah kelewatan, mending stop belanja dulu hari ini!';
      }
    }

    if (scenario == BudgetHealthScenario.deficit) {
      if (balance <= 0 && totalUnpaidFixedCost > 0) {
        return 'Kamu udah nggak punya saldo buat bayar biaya tetap dan jajan harian!';
      }

      return 'Saldo kamu udah minus. Setiap pengeluaran hari ini bakal bikin defisit makin besar.';
    }

    return 'Statusnya belum ketemu.';
  }

  String _resolveUsername(String username) {
    final splitted = username.split(' ');

    if (splitted.first.length < 3) {
      return splitted.sublist(0, 2).join(' ');
    }

    return splitted.first;
  }
}
