import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_state.dart';
import 'package:money_management_mobile/features/dashboard/domain/usecases/calculate_dashboard_metrics_usecase.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_state.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/financial_health_badge.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/calculate_financial_profile_usecase.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionState = context.read<SessionCubit>().state;
    final username = sessionState is SessionAuthenticated
        ? _resolveUsername(sessionState.user.name)
        : 'Guest';

    final dashboardState = context.watch<DashboardMetricCubit>().state;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hai, $username!',
                style: Theme.of(context).textTheme.headlineLarge,
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
                  'Memuat data dashboard...',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ] else ...[
                Text(
                  'Gagal memuat data dashboard',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (dashboardState is DashboardMetricLoaded) ...[
          const SizedBox(width: AppSizes.spacing4),
          BudgetHealthBadge(status: dashboardState.metrics.healthScenario),
        ],
      ],
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
        return 'Sedang di jalur hemat! Pertahankan agar tabungan maksimal.';
      } else if (limitState == DashboardLimitState.overFirstLimit) {
        return 'Limit optimal terlewati! Jatah tabungan akan berkurang seiring transaksi bertambah.';
      } else {
        return 'Melewati batas, jatah harian aktual besok akan berkurang!';
      }
    }

    if (scenario == BudgetHealthScenario.moderate) {
      if (limitState == DashboardLimitState.underFirstLimit ||
          limitState == DashboardLimitState.overFirstLimit) {
        return 'Kondisi aman. Jaga pengeluaran tetap di bawah batas harian aktual.';
      } else {
        return 'Batas harian aktual terlewati, sebaiknya berhenti belanja hari ini!';
      }
    }

    if (scenario == BudgetHealthScenario.critical) {
      if (limitState == DashboardLimitState.underFirstLimit) {
        return 'Saldo sangat terbatas! Tetap di mode Hemat Ekstrem agar cukup sampai akhir bulan.';
      } else if (limitState == DashboardLimitState.overFirstLimit) {
        return 'Mode Hemat Ekstrem terlewati. Anda sekarang menggunakan jatah “Bertahan Hidup”.';
      } else {
        return 'Batas harian aktual terlewati, sebaiknya berhenti belanja hari ini!';
      }
    }

    if (scenario == BudgetHealthScenario.deficit) {
      if (balance <= 0 && totalUnpaidFixedCost > 0) {
        return 'Anda tidak memiliki saldo untuk membayar fixed cost dan jajan harian!';
      }

      return 'Saldo Anda sudah minus. Setiap pengeluaran hari ini akan memperbesar total defisit Anda.';
    }

    return 'Status tidak dikenal.';
  }

  String _resolveUsername(String username) {
    final splitted = username.split(' ');

    if (splitted.first.length < 3) {
      return splitted.sublist(0, 2).join(' ');
    }

    return splitted.first;
  }
}
