import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_currency_text_field.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_state.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/submit_financial_profile_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/step_progress_indicator.dart';

class Step1PersonalizationPage extends StatefulWidget {
  const Step1PersonalizationPage({super.key});

  @override
  State<Step1PersonalizationPage> createState() =>
      _Step1PersonalizationPageState();
}

class _Step1PersonalizationPageState extends State<Step1PersonalizationPage> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FinancialProfileDraftCubit>().resetDraft();
    context.read<SubmitFinancialProfileCubit>().reset();
    final state = context.read<FinancialProfileDraftCubit>().state;
    if (state.initialBalance > 0) {
      _amountController.text = CurrencyFormatter.format(state.initialBalance);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialProfileDraftCubit, FinancialProfileDraftState>(
      builder: (context, state) {
        final isWeekly = state.budgetCycle == BudgetCycle.weekly;

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
                      children: [
                        const SizedBox(height: AppSizes.spacing4),
                        const StepProgressIndicator(
                          currentStep: 1,
                          totalSteps: 4,
                        ),
                        const SizedBox(height: AppSizes.spacing7),
                        Text(
                          'Saldo Awal & Siklus Budget',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(color: AppColors.primary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSizes.spacing2),
                        Text(
                          'Pilih siklus budget dan masukkan saldo awal Anda.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.trunks),
                        ),
                        const SizedBox(height: AppSizes.spacing10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildCycleCard(
                                title: 'Bulanan',
                                icon: Icons.calendar_month_outlined,
                                isSelected: !isWeekly,
                                onTap: () => context
                                    .read<FinancialProfileDraftCubit>()
                                    .updateBudgetCycle(BudgetCycle.monthly),
                              ),
                            ),
                            const SizedBox(width: AppSizes.spacing4),
                            Expanded(
                              child: _buildCycleCard(
                                title: 'Mingguan',
                                icon: Icons.wb_sunny_outlined,
                                isSelected: isWeekly,
                                onTap: () => context
                                    .read<FinancialProfileDraftCubit>()
                                    .updateBudgetCycle(BudgetCycle.weekly),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.spacing5),
                        AppCurrencyTextField(
                          controller: _amountController,
                          hint: 'Rp. 0',
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            context
                                .read<FinancialProfileDraftCubit>()
                                .updateInitialBalance(
                                  CurrencyFormatter.parse(value),
                                );
                          },
                        ),
                        const SizedBox(height: AppSizes.spacing3),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _buildCycleHint(isWeekly),
                        ),
                        const SizedBox(height: AppSizes.spacing10),
                        AppButton(
                          text: 'Selanjutnya',
                          onPressed: () {
                            if (state.initialBalance <= 0) {
                              _showError('Nominal saldo awal wajib diisi');
                              return;
                            }

                            context.push(AppRouter.step2Personalization);
                          },
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
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.danger100),
    );
  }

  Widget _buildCycleHint(bool isWeekly) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isWeekly ? 'Siklus Mingguan' : 'Siklus Bulanan',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.trunks,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: AppSizes.spacing1),
        Tooltip(
          message: isWeekly
              ? 'Budget dibagi untuk sisa hari sampai akhir minggu ini.'
              : 'Budget dibagi untuk sisa hari sampai akhir bulan ini.',
          child: const Icon(
            Icons.info_outline,
            size: 16,
            color: AppColors.trunks,
          ),
        ),
      ],
    );
  }

  Widget _buildCycleCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusNm),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.beerus,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.trunks,
              size: 20,
            ),
            const SizedBox(width: AppSizes.spacing2),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.primary : AppColors.bulma,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 16,
              color: isSelected ? AppColors.primary : AppColors.trunks,
            ),
          ],
        ),
      ),
    );
  }
}
