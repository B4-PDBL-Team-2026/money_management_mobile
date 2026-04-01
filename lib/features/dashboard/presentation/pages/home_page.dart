import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_state.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/unpaid_fixed_cost_occurrences_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/unpaid_fixed_cost_occurrences_state.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/dashboard_budget_metrics.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:money_management_mobile/features/dashboard/domain/entities/unpaid_fixed_cost_entity.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/unpaid_fixed_cost_card.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_history_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_history_state.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/transaction_history_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.spacing6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocListener<DashboardMetricCubit, DashboardMetricState>(
                listener: (context, state) {
                  if (state is DashboardMetricError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                child: Column(
                  children: [
                    DashboardHeader(),
                    const SizedBox(height: AppSizes.spacing6),
                    DashboardBudgetMetrics(),
                  ],
                ),
              ),
              BlocConsumer<
                UnpaidFixedCostOccurrencesCubit,
                UnpaidFixedCostOccurrencesState
              >(
                listener: (context, state) {
                  if (state is UnpaidFixedCostOccurrencesError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.danger100,
                        content: Text(state.message),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is! UnpaidFixedCostOccurrencesLoaded ||
                      state.items.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final now = DateTime.now();

                  final weeklyItems = state.items
                      .where(
                        (item) =>
                            item.cycle == FinancialCycle.weekly &&
                            _isInCurrentWeek(item.dueDate, now),
                      )
                      .toList(growable: false);

                  final monthlyItems = state.items
                      .where(
                        (item) =>
                            item.cycle == FinancialCycle.monthly &&
                            _isInCurrentMonth(item.dueDate, now),
                      )
                      .toList(growable: false);

                  if (weeklyItems.isEmpty && monthlyItems.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (weeklyItems.isNotEmpty) ...[
                        const SizedBox(height: AppSizes.spacing6),
                        _FixedCostSection(
                          title: 'Fixed Cost Mingguan di Minggu Ini',
                          items: weeklyItems,
                        ),
                      ],

                      if (monthlyItems.isNotEmpty) ...[
                        const SizedBox(height: AppSizes.spacing6),
                        _FixedCostSection(
                          title: 'Fixed Cost Bulanan di Bulan Ini',
                          items: monthlyItems,
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSizes.spacing6),
              BlocConsumer<TransactionHistoryCubit, TransactionHistoryState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is! TransactionHistorySuccess) {
                    return SizedBox.shrink();
                  }

                  if (state.transactionHistory.isEmpty) {
                    return SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaksi Terbaru',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: AppSizes.spacing3),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => TransactionHistoryItem(
                          transaction: state.transactionHistory[index],
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSizes.spacing2),
                        itemCount: state.transactionHistory.isEmpty
                            ? 0
                            : state.transactionHistory.length > 3
                            ? 3
                            : state.transactionHistory.length,
                      ),
                      const SizedBox(height: AppSizes.spacing6),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static bool _isInCurrentWeek(DateTime? date, DateTime now) {
    if (date == null) {
      return false;
    }

    final weekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    final weekEndExclusive = weekStart.add(const Duration(days: 7));
    final dueDate = DateTime(date.year, date.month, date.day);

    return !dueDate.isBefore(weekStart) && dueDate.isBefore(weekEndExclusive);
  }

  static bool _isInCurrentMonth(DateTime? date, DateTime now) {
    if (date == null) {
      return false;
    }

    return date.year == now.year && date.month == now.month;
  }
}

class _FixedCostSection extends StatelessWidget {
  final String title;
  final List<UnpaidFixedCostEntity> items;

  const _FixedCostSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontSize: 16),
        ),
        const SizedBox(height: AppSizes.spacing3),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = items[index];

            return UnpaidFixedCostCard(
              item: item,
              isPayEnabled: true,
              onPay: () async {
                final success = await context
                    .read<UnpaidFixedCostOccurrencesCubit>()
                    .confirmFixedCostOccurrence(item.occurrenceId);

                if (!success || !context.mounted) {
                  return;
                }

                await context
                    .read<TransactionHistoryCubit>()
                    .getFreshTransactionHistory();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.success100,
                      content: Text('Fixed cost berhasil dibayar'),
                    ),
                  );
                }
              },
              onCancel: () async {
                final success = await context
                    .read<UnpaidFixedCostOccurrencesCubit>()
                    .cancelFixedCostOccurrence(item.occurrenceId);

                if (!success || !context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.warning100,
                    content: Text('Fixed cost berhasil dibatalkan'),
                  ),
                );
              },
            );
          },
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSizes.spacing2),
          itemCount: items.length,
        ),
      ],
    );
  }
}
