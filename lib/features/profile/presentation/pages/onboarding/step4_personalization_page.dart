import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_state.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/submit_financial_profile_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/submit_financial_profile_state.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/final_preview_summary_card.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/fixed_cost_item_card.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/step_progress_indicator.dart';

class Step4PersonalizationPage extends StatelessWidget {
  const Step4PersonalizationPage({super.key});

  static const List<MapEntry<int, String>> _weekdayOptions = [
    MapEntry(1, 'Senin'),
    MapEntry(2, 'Selasa'),
    MapEntry(3, 'Rabu'),
    MapEntry(4, 'Kamis'),
    MapEntry(5, 'Jumat'),
    MapEntry(6, 'Sabtu'),
    MapEntry(7, 'Minggu'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      SubmitFinancialProfileCubit,
      SubmitFinancialProfileState
    >(
      listener: (context, state) {
        if (state is SubmitFinancialProfileSuccess) {
          context.go(AppRouter.dashboard);
          return;
        }

        if (state is SubmitFinancialProfileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.danger100,
            ),
          );
        }
      },
      builder: (context, submitState) {
        return BlocBuilder<
          FinancialProfileDraftCubit,
          FinancialProfileDraftState
        >(
          builder: (context, wizardState) {
            final draftCubit = context.read<FinancialProfileDraftCubit>();
            final calculation = draftCubit.calculateBudget();

            return Scaffold(
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSizes.spacing6),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: AppSizes.spacing6),
                            const StepProgressIndicator(
                              currentStep: 4,
                              totalSteps: 4,
                            ),
                            const SizedBox(height: AppSizes.spacing8),
                            Text(
                              'Final Preview & Proyeksi',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayMedium
                                  ?.copyWith(color: AppColors.primary),
                            ),
                            const SizedBox(height: AppSizes.spacing3),
                            Text(
                              'Ringkasan ini dihitung dinamis berdasarkan tanggal hari ini dan hanya menghitung fixed cost yang jatuh tempo di sisa siklus aktif.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.trunks),
                            ),
                            const SizedBox(height: AppSizes.spacing6),
                            FinalPreviewSummaryCard(
                              cycle: wizardState.budgetCycle,
                              initialBalance: wizardState.initialBalance,
                              safetyCeiling: wizardState.safetyCeiling,
                              remainingDays: calculation.remainingDays,
                              totalFixedCost: calculation.totalFixedCost,
                              dailyBudgetBruto: calculation.dailyBudgetBruto,
                              projectedSavings: calculation.projectedSavings,
                            ),
                            const SizedBox(height: AppSizes.spacing6),
                            Text(
                              'Fixed Cost Valid',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.trunks,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                            const SizedBox(height: AppSizes.spacing3),
                            if (calculation.validFixedCosts.isEmpty)
                              Text(
                                'Tidak ada fixed cost valid pada sisa siklus ini.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.trunks),
                              )
                            else
                              Column(
                                children: calculation.validFixedCosts
                                    .map(
                                      (item) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: AppSizes.spacing3,
                                        ),
                                        child: FixedCostItemCard(
                                          name: item.fixedCost.name,
                                          category: item.fixedCost.category,
                                          cycle:
                                              item.fixedCost.cycle == 'weekly'
                                              ? 'Mingguan'
                                              : 'Bulanan',
                                          dueLabel: _buildDueLabel(
                                            dueValue: item.fixedCost.dueValue,
                                            frequency: item.fixedCost.cycle,
                                          ),
                                          amount:
                                              'Rp ${CurrencyFormatter.format(item.scaledAmount)}',
                                        ),
                                      ),
                                    )
                                    .toList(growable: false),
                              ),
                            const SizedBox(height: AppSizes.spacing8),
                            Row(
                              children: [
                                Expanded(
                                  child: AppButton(
                                    text: 'Sebelumnya',
                                    onPressed: context.pop,
                                    variant: AppButtonVariant.ghost,
                                  ),
                                ),
                                const SizedBox(width: AppSizes.spacing2),
                                Expanded(
                                  child: AppButton(
                                    text: 'Selesai',
                                    isLoading:
                                        submitState
                                            is SubmitFinancialProfileLoading,
                                    onPressed: () {
                                      context
                                          .read<SubmitFinancialProfileCubit>()
                                          .submit(
                                            FinancialProfileEntity(
                                              budgetCycle:
                                                  wizardState.budgetCycle,
                                              initialBalance:
                                                  wizardState.initialBalance,
                                              safetyCeiling:
                                                  wizardState.safetyCeiling,
                                              fixedCosts:
                                                  wizardState.fixedCosts,
                                            ),
                                          );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _buildDueLabel({required int dueValue, required String frequency}) {
    if (frequency == 'weekly') {
      return _weekdayOptions.firstWhere((item) => item.key == dueValue).value;
    }

    return 'Tanggal $dueValue';
  }
}
