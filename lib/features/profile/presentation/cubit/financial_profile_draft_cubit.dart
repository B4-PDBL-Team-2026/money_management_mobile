import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_entity.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/calculate_onboarding_budget_usecase.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_state.dart';

class FinancialProfileDraftCubit extends Cubit<FinancialProfileDraftState> {
  final CalculateOnboardingBudgetUseCase calculateOnboardingBudgetUseCase;

  FinancialProfileDraftCubit(this.calculateOnboardingBudgetUseCase)
    : super(FinancialProfileDraftState.initial());

  void resetDraft() {
    emit(FinancialProfileDraftState.initial());
  }

  void updateBudgetCycle(BudgetCycle budgetCycle) {
    emit(state.copyWith(budgetCycle: budgetCycle));
  }

  void updateInitialBalance(int initialBalance) {
    emit(state.copyWith(initialBalance: initialBalance));
  }

  void updateSafetyCeiling(int safetyCeiling) {
    emit(state.copyWith(safetyCeiling: safetyCeiling));
  }

  void addFixedCost({
    required String name,
    required int amount,
    required String category,
    required String cycle,
    required int dueValue,
  }) {
    final updatedFixedCosts = List<FixedCostEntity>.from(state.fixedCosts)
      ..add(
        FixedCostEntity(
          name: name,
          amount: amount,
          category: category,
          cycle: cycle,
          dueValue: dueValue,
        ),
      );

    emit(state.copyWith(fixedCosts: updatedFixedCosts));
  }

  void removeFixedCostAt(int index) {
    if (index < 0 || index >= state.fixedCosts.length) {
      return;
    }

    final updatedFixedCosts = List<FixedCostEntity>.from(state.fixedCosts)
      ..removeAt(index);

    emit(state.copyWith(fixedCosts: updatedFixedCosts));
  }

  OnboardingBudgetCalculationResult calculateBudget({DateTime? now}) {
    return calculateOnboardingBudgetUseCase.execute(_currentProfile, now: now);
  }

  FinancialProfileEntity get _currentProfile {
    return FinancialProfileEntity(
      budgetCycle: state.budgetCycle,
      initialBalance: state.initialBalance,
      safetyCeiling: state.safetyCeiling,
      fixedCosts: state.fixedCosts,
    );
  }
}
