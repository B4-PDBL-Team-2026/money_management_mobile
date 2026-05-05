import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/theme/app_text_styles.dart';
import 'package:money_management_mobile/features/dashboard/domain/entities/unpaid_fixed_cost_entity.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_state.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/unpaid_fixed_cost_occurrences_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/unpaid_fixed_cost_occurrences_state.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/unpaid_fixed_cost_card.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// TODO: memindahkan semua kode fixed cost occurences ke fitur fixed cost
class FixedCostOccurencePage extends StatelessWidget {
  const FixedCostOccurencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSizes.spacing6,
            AppSizes.spacing6,
            AppSizes.spacing6,
            AppSizes.spacing8,
          ),
          child: Column(
            children: [
              _buildHeader(context),
              BlocConsumer<
                UnpaidFixedCostTemplateCubit,
                UnpaidFixedCostTemplateState
              >(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is! UnpaidFixedCostTemplateLoaded) {
                    return const _LoadingState();
                  }

                  if (state.items.isEmpty) {
                    return _EmptyFixedCostState(
                      onManage: () =>
                          context.push(AppRouter.fixedCostsManagement),
                    );
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
                          title: 'Minggu Ini',
                          items: weeklyItems,
                        ),
                      ],

                      if (monthlyItems.isNotEmpty) ...[
                        const SizedBox(height: AppSizes.spacing6),
                        _FixedCostSection(
                          title: 'Bulan Ini',
                          items: monthlyItems,
                        ),
                      ],
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

  Row _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Biaya tetap',
          style: AppTextStyles.h1.copyWith(color: AppColors.primary),
        ),
        GestureDetector(
          onTap: () {
            context.push(AppRouter.fixedCostsManagement);
          },
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.all(
                Radius.circular(AppSizes.radiusSm),
              ),
            ),
            child: PhosphorIcon(
              PhosphorIconsRegular.pencil,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  /* utils */

  bool _isInCurrentWeek(DateTime? date, DateTime now) {
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

  bool _isInCurrentMonth(DateTime? date, DateTime now) {
    if (date == null) {
      return false;
    }

    return date.year == now.year && date.month == now.month;
  }
}

class _FixedCostSection extends StatelessWidget {
  final String title;
  final List<UnpaidFixedCostTemplateEntity> items;

  const _FixedCostSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final dashboardMetricState = context.watch<DashboardMetricCubit>().state;
    final isPayEnabled =
        dashboardMetricState is DashboardMetricLoaded &&
        dashboardMetricState.metrics.balance > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h2),
        const SizedBox(height: AppSizes.spacing3),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = items[index];

            return UnpaidFixedCostCard(
              item: item,
              isPayEnabled: isPayEnabled,
              onPay: () async {
                final success = await context
                    .read<UnpaidFixedCostTemplateCubit>()
                    .confirmFixedCostOccurrence(item.occurrenceId);

                if (!success || !context.mounted) {
                  return;
                }

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
                    .read<UnpaidFixedCostTemplateCubit>()
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

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.spacing12),
      child: const CircularProgressIndicator(),
    );
  }
}

class _EmptyFixedCostState extends StatelessWidget {
  final VoidCallback onManage;

  const _EmptyFixedCostState({required this.onManage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.spacing12,
        horizontal: AppSizes.spacing4,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.spacing6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: PhosphorIcon(
              PhosphorIconsLight.receipt,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: AppSizes.spacing6),
          Text(
            'Tidak Ada Biaya Tetap',
            style: AppTextStyles.h2.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.spacing2),
          Text(
            'Anda belum memiliki biaya tetap yang dijadwalkan untuk minggu atau bulan ini.',
            style: AppTextStyles.bodyMain.copyWith(color: AppColors.bulma),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.spacing6),
          GestureDetector(
            onTap: onManage,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.spacing4,
                vertical: AppSizes.spacing3,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Text(
                'Kelola Biaya Tetap',
                style: AppTextStyles.bodyMain.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
