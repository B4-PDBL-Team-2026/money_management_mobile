import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/calculate_onboarding_budget_usecase.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_state.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/submit_financial_profile_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/submit_financial_profile_state.dart';
import 'package:money_management_mobile/features/profile/presentation/utils/profile_utils.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/final_preview_summary_card.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/fixed_cost_item_card.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/step_progress_indicator.dart';

class Step4PersonalizationPage extends StatelessWidget {
  const Step4PersonalizationPage({super.key});

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
            final scenario = calculation.scenario;

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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: AppSizes.spacing6),
                            const StepProgressIndicator(
                              currentStep: 4,
                              totalSteps: 4,
                            ),
                            const SizedBox(height: AppSizes.spacing8),
                            Text(
                              'Ringkasan Akhir',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayMedium
                                  ?.copyWith(color: AppColors.primary),
                            ),
                            const SizedBox(height: AppSizes.spacing3),
                            Text(
                              _shortDescriptionByScenario(scenario),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.trunks),
                            ),
                            const SizedBox(height: AppSizes.spacing6),
                            FinalPreviewSummaryCard(
                              scenario: scenario,
                              cycle: wizardState.budgetCycle,
                              initialBalance: wizardState.initialBalance,
                              safetyCeiling: wizardState.safetyCeiling,
                              safetyFlooring: wizardState.safetyFlooring,
                              remainingDays: calculation.remainingDays,
                              totalFixedCost: calculation.totalFixedCost,
                              deficitBalance: calculation.deficitBalance,
                              daysCoveredAtSafetyFloor:
                                  calculation.daysCoveredAtSafetyFloor,
                              dailyBudgetBruto: calculation.dailyBudgetBruto,
                              recommendedDailyBudget:
                                  calculation.recommendedDailyBudget,
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
                                          cycle: ProfileUtils.buildCycleLabel(
                                            item.fixedCost.cycle,
                                          ),
                                          dueLabel: ProfileUtils.buildDueLabel(
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
                                              safetyFlooring:
                                                  wizardState.safetyFlooring,
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

  String _shortDescriptionByScenario(BudgetHealthScenario scenario) {
    return switch (scenario) {
      BudgetHealthScenario.surplus =>
        'Saldo aman, Anda berpotensi menabung di akhir siklus.',
      BudgetHealthScenario.moderate =>
        'Kondisi stabil, jaga pengeluaran tetap sesuai batas harian.',
      BudgetHealthScenario.critical =>
        'Saldo terbatas, atur pengeluaran harian lebih ketat.',
      BudgetHealthScenario.deficit =>
        'Defisit: total tagihan melebihi saldo sampai akhir siklus.',
    };
  }
}
