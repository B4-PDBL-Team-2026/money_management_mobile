import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/constants/default_categories.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_entity.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_state.dart';
import 'package:money_management_mobile/features/profile/presentation/utils/profile_utils.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/fixed_cost_bottom_sheet.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/fixed_cost_item_card.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/step_progress_indicator.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/category.dart';

class Step3PersonalizationPage extends StatefulWidget {
  const Step3PersonalizationPage({super.key});

  @override
  State<Step3PersonalizationPage> createState() =>
      _Step3PersonalizationPageState();
}

class _Step3PersonalizationPageState extends State<Step3PersonalizationPage> {
  List<Category> get _expenseCategories => DefaultCategories.expenses;

  void _showAddExpenseBottomSheet() {
    final draftCubit = context.read<FinancialProfileDraftCubit>();
    final isMainCycleWeekly =
        draftCubit.state.budgetCycle == FinancialCycle.weekly;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => AddFixedCostBottomSheet(
        draftCubit: draftCubit,
        isMainCycleWeekly: isMainCycleWeekly,
        expenseCategories: _expenseCategories,
      ),
    );
  }

  void _showEditExpenseBottomSheet({
    required int index,
    required FixedCostEntity item,
  }) {
    final draftCubit = context.read<FinancialProfileDraftCubit>();
    final isMainCycleWeekly =
        draftCubit.state.budgetCycle == FinancialCycle.weekly;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => AddFixedCostBottomSheet(
        draftCubit: draftCubit,
        isMainCycleWeekly: isMainCycleWeekly,
        expenseCategories: _expenseCategories,
        editingIndex: index,
        initialItem: item,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialProfileDraftCubit, FinancialProfileDraftState>(
      builder: (context, state) {
        final cycleLabel = ProfileUtils.buildCycleLabel(state.budgetCycle);

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.spacing6),
              child: Column(
                children: [
                  const SizedBox(height: AppSizes.spacing4),
                  const StepProgressIndicator(currentStep: 3, totalSteps: 4),
                  const SizedBox(height: AppSizes.spacing7),
                  Text(
                    'Biaya Rutin',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.spacing2),
                  Text(
                    'Tambahkan fixed cost agar proyeksi budget lebih akurat.',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
                  ),
                  const SizedBox(height: AppSizes.spacing3),
                  _buildStepHint(cycleLabel, state.budgetCycle),
                  const SizedBox(height: AppSizes.spacing5),
                  AppButton(
                    text: 'Tambah Fixed Cost',
                    onPressed: _showAddExpenseBottomSheet,
                    variant: AppButtonVariant.outlined,
                  ),
                  const SizedBox(height: AppSizes.spacing4),
                  if (state.fixedCosts.isEmpty)
                    _buildEmptyState()
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.fixedCosts.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSizes.spacing4),
                      itemBuilder: (context, index) {
                        final item = state.fixedCosts[index];

                        return FixedCostItemCard(
                          name: item.name,
                          category: item.category,
                          cycle: ProfileUtils.buildCycleLabel(item.cycle),
                          dueLabel: ProfileUtils.buildDueLabel(
                            dueValue: item.dueValue,
                            frequency: item.cycle,
                          ),
                          amount:
                              'Rp ${CurrencyFormatter.format(item.amount.toInt())}',
                          showDeleteAction: true,
                          onDelete: () => context
                              .read<FinancialProfileDraftCubit>()
                              .removeFixedCostAt(index),
                          showEditAction: true,
                          onEdit: () => _showEditExpenseBottomSheet(
                            index: index,
                            item: item,
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: AppSizes.spacing7),
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
                          text: state.fixedCosts.isEmpty
                              ? 'Lewati'
                              : 'Selanjutnya',
                          onPressed: () {
                            context.push(AppRouter.step4Personalization);
                          },
                          variant: state.fixedCosts.isEmpty
                              ? AppButtonVariant.ghost
                              : AppButtonVariant.filled,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacing5),
      decoration: BoxDecoration(
        color: AppColors.gohan,
        borderRadius: BorderRadius.circular(AppSizes.radiusNm),
        border: Border.all(color: AppColors.beerus),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: AppSizes.spacing6,
            color: AppColors.trunks,
          ),
          const SizedBox(height: AppSizes.spacing2),
          Text(
            'Belum ada fixed cost',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.bulma,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.spacing1),
          Text(
            'Anda bisa lewati langkah ini atau tambah satu biaya rutin terlebih dulu.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
          ),
        ],
      ),
    );
  }

  Widget _buildStepHint(String cycleLabel, FinancialCycle cycle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Siklus aktif: $cycleLabel',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.trunks,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: AppSizes.spacing1),
        Tooltip(
          message: cycle == FinancialCycle.monthly
              ? 'Biaya mingguan akan disesuaikan dengan sisa minggu pada bulan berjalan.'
              : 'Biaya rutin akan dihitung untuk sisa hari pada minggu berjalan.',
          child: const Icon(
            Icons.info_outline,
            size: 16,
            color: AppColors.trunks,
          ),
        ),
      ],
    );
  }
}
