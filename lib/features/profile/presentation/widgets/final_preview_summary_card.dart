import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/calculate_financial_profile_usecase.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/final_preview_summary_row.dart';

class FinalPreviewSummaryCard extends StatelessWidget {
  const FinalPreviewSummaryCard({
    super.key,
    required this.scenario,
    required this.cycle,
    required this.initialBalance,
    required this.safetyCeiling,
    required this.safetyFlooring,
    required this.remainingDays,
    required this.totalFixedCost,
    required this.deficitBalance,
    required this.daysCoveredAtSafetyFloor,
    required this.dailyBudgetBruto,
    required this.recommendedDailyBudget,
    required this.projectedSavings,
  });

  final BudgetHealthScenario scenario;
  final FinancialCycle cycle;
  final int initialBalance;
  final int safetyCeiling;
  final int safetyFlooring;
  final int remainingDays;
  final int totalFixedCost;
  final int deficitBalance;
  final int daysCoveredAtSafetyFloor;
  final int dailyBudgetBruto;
  final int recommendedDailyBudget;
  final int projectedSavings;

  @override
  Widget build(BuildContext context) {
    final cycleLabel = cycle == FinancialCycle.weekly ? 'Mingguan' : 'Bulanan';

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.spacing5),
          decoration: BoxDecoration(
            color: AppColors.gohan,
            borderRadius: BorderRadius.circular(AppSizes.radiusNm),
            border: Border.all(color: AppColors.beerus),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Kondisi Keuangan',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.trunks,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spacing3,
                      vertical: AppSizes.spacing1,
                    ),
                    decoration: BoxDecoration(
                      color: _scenarioBadgeBackground,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    ),
                    child: Text(
                      _scenarioName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _scenarioBadgeText,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spacing4),
              FinalPreviewSummaryRow(
                label: 'Siklus',
                value: cycleLabel,
                valueColor: AppColors.primary,
              ),
              FinalPreviewSummaryRow(
                label: 'Saldo Awal',
                value: 'Rp ${CurrencyFormatter.format(initialBalance)}',
              ),
              FinalPreviewSummaryRow(
                label: 'Sisa Hari',
                value: '$remainingDays hari',
              ),
              FinalPreviewSummaryRow(
                label: 'Total Fixed Cost',
                value: 'Rp ${CurrencyFormatter.format(totalFixedCost)}',
              ),
              FinalPreviewSummaryRow(
                label: 'Jatah Harian Aktual',
                value: scenario == BudgetHealthScenario.deficit
                    ? '-Rp ${CurrencyFormatter.format(dailyBudgetBruto.abs())}'
                    : 'Rp ${CurrencyFormatter.format(dailyBudgetBruto)}',
                valueColor: scenario == BudgetHealthScenario.deficit
                    ? AppColors.danger100
                    : null,
                isLast: true,
              ),
            ],
          ),
        ),
        if (scenario != BudgetHealthScenario.moderate) ...[
          const SizedBox(height: AppSizes.spacing4),
          _buildInsightCard(context),
        ],
      ],
    );
  }

  Widget _buildInsightCard(BuildContext context) {
    if (scenario == BudgetHealthScenario.surplus) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.spacing4),
        decoration: BoxDecoration(
          color: AppColors.success10,
          borderRadius: BorderRadius.circular(AppSizes.radiusNm),
          border: Border.all(color: AppColors.success60),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Strategi Optimal',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.success100,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: AppSizes.spacing3),
            FinalPreviewSummaryRow(
              label: 'Jatah Harian',
              value: 'Rp ${CurrencyFormatter.format(recommendedDailyBudget)}',
              valueColor: AppColors.success100,
            ),
            FinalPreviewSummaryRow(
              label: 'Potensi Tabungan',
              value: 'Rp ${CurrencyFormatter.format(projectedSavings)}',
              valueColor: AppColors.success100,
              isLast: true,
            ),
            const SizedBox(height: AppSizes.spacing3),
            Text(
              'Anda memiliki potensi tabungan di akhir siklus jika disiplin',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
            ),
          ],
        ),
      );
    }

    if (scenario == BudgetHealthScenario.critical) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.spacing4),
        decoration: BoxDecoration(
          color: AppColors.warning10,
          borderRadius: BorderRadius.circular(AppSizes.radiusNm),
          border: Border.all(color: AppColors.warning100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dua Strategi Bertahan',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.warning100,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: AppSizes.spacing3),
            FinalPreviewSummaryRow(
              label: 'Bertahan Hidup',
              value:
                  'Rp ${CurrencyFormatter.format(recommendedDailyBudget)}/hari',
              valueColor: AppColors.warning100,
              isLast: true,
            ),
            const SizedBox(height: AppSizes.spacing2),
            if (recommendedDailyBudget < safetyFlooring ||
                daysCoveredAtSafetyFloor == 1) ...[
              Text(
                'Konsekuensi: hanya bertahan hari ini, selanjutnya saldo akan defisit.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
              ),
            ] else ...[
              Text(
                'Konsekuensi: hanya bertahan $daysCoveredAtSafetyFloor hari selanjutnya saldo akan defisit.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
              ),
            ],
            const SizedBox(height: AppSizes.spacing3),
            FinalPreviewSummaryRow(
              label: 'Hemat Ekstrem',
              value: 'Rp ${CurrencyFormatter.format(dailyBudgetBruto)}/hari',
              valueColor: AppColors.warning100,
              isLast: true,
            ),
            const SizedBox(height: AppSizes.spacing2),
            Text(
              'Konsekuensi: bertahan $remainingDays hari (full siklus).',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacing4),
      decoration: BoxDecoration(
        color: AppColors.danger10,
        borderRadius: BorderRadius.circular(AppSizes.radiusNm),
        border: Border.all(color: AppColors.danger60),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Anda hidup dalam hutang',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.danger100,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSizes.spacing3),
          FinalPreviewSummaryRow(
            label: 'Defisit Saldo',
            value: '-Rp ${CurrencyFormatter.format(deficitBalance)}',
            valueColor: AppColors.danger100,
            isLast: true,
          ),
          const SizedBox(height: AppSizes.spacing3),
          FinalPreviewSummaryRow(
            label: 'Jatah Harian Maksimal',
            value: 'Rp ${CurrencyFormatter.format(recommendedDailyBudget)}',
            valueColor: AppColors.danger100,
            isLast: true,
          ),
          const SizedBox(height: AppSizes.spacing3),
          Text(
            'Jatah tersebut dari batas minimal anda. Setiap pengeluaran akan memperbesar defisit Anda. Cari pemasukan atau pangkas fixed cost Anda!',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.danger100,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String get _scenarioName {
    return switch (scenario) {
      BudgetHealthScenario.surplus => 'Surplus',
      BudgetHealthScenario.moderate => 'Stabil',
      BudgetHealthScenario.critical => 'Kritis',
      BudgetHealthScenario.deficit => 'Defisit',
    };
  }

  Color get _scenarioBadgeBackground {
    return switch (scenario) {
      BudgetHealthScenario.surplus => AppColors.success100,
      BudgetHealthScenario.moderate => AppColors.secondary,
      BudgetHealthScenario.critical => AppColors.warning100,
      BudgetHealthScenario.deficit => AppColors.danger100,
    };
  }

  Color get _scenarioBadgeText {
    return switch (scenario) {
      BudgetHealthScenario.surplus => Colors.white,
      BudgetHealthScenario.moderate => Colors.white,
      BudgetHealthScenario.critical => Colors.white,
      BudgetHealthScenario.deficit => Colors.white,
    };
  }
}
