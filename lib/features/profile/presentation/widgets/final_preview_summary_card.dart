import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/final_preview_summary_row.dart';

class FinalPreviewSummaryCard extends StatelessWidget {
  const FinalPreviewSummaryCard({
    super.key,
    required this.cycle,
    required this.initialBalance,
    required this.safetyCeiling,
    required this.remainingDays,
    required this.totalFixedCost,
    required this.dailyBudgetBruto,
    required this.projectedSavings,
  });

  final BudgetCycle cycle;
  final int initialBalance;
  final int safetyCeiling;
  final int remainingDays;
  final int totalFixedCost;
  final int dailyBudgetBruto;
  final int projectedSavings;

  @override
  Widget build(BuildContext context) {
    final cycleLabel = cycle == BudgetCycle.weekly ? 'Mingguan' : 'Bulanan';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacing5),
      decoration: BoxDecoration(
        color: AppColors.lightPrimary,
        borderRadius: BorderRadius.circular(AppSizes.radiusNm),
        border: Border.all(color: AppColors.primary),
      ),
      child: Column(
        children: [
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
            label: 'Safety Ceiling',
            value: 'Rp ${CurrencyFormatter.format(safetyCeiling)}',
          ),
          FinalPreviewSummaryRow(
            label: 'Sisa Hari',
            value: '$remainingDays hari',
          ),
          FinalPreviewSummaryRow(
            label: 'Total Fixed Cost Valid',
            value: 'Rp ${CurrencyFormatter.format(totalFixedCost)}',
          ),
          FinalPreviewSummaryRow(
            label: 'Daily Budget Bruto',
            value: 'Rp ${CurrencyFormatter.format(dailyBudgetBruto)}',
          ),
          FinalPreviewSummaryRow(
            label: 'Proyeksi Tabungan',
            value: 'Rp ${CurrencyFormatter.format(projectedSavings)}',
            valueColor: AppColors.success100,
            isLast: true,
          ),
        ],
      ),
    );
  }
}
