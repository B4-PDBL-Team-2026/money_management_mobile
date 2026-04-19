import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_template_entity.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/calculate_financial_profile_usecase.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_state.dart';

@LazySingleton()
class FinancialProfileDraftCubit extends Cubit<FinancialProfileDraftState> {
  final CalculateFinancialProfileUseCase calculateOnboardingBudgetUseCase;

  FinancialProfileDraftCubit(this.calculateOnboardingBudgetUseCase)
    : super(FinancialProfileDraftState.initial());

  void resetDraft() {
    emit(FinancialProfileDraftState.initial());
  }

  void updateFinancialCycle(FinancialCycle budgetCycle) {
    emit(state.copyWith(budgetCycle: budgetCycle));
  }

  void updateInitialBalance(int initialBalance) {
    emit(state.copyWith(initialBalance: initialBalance));
  }

  void updateSafetyCeiling(int safetyCeiling) {
    emit(state.copyWith(safetyCeiling: safetyCeiling));
  }

  void updateSafetyFlooring(int safetyFlooring) {
    emit(state.copyWith(safetyFlooring: safetyFlooring));
  }

  void addFixedCost({
    required String name,
    required int amount,
    required String category,
    required int categoryId,
    CategoryType categoryType = CategoryType.system,
    bool isActive = true,
    required FinancialCycle cycle,
    required int dueValue,
  }) {
    final updatedFixedCosts = List<FixedCostTemplateEntity>.from(state.fixedCosts)
      ..add(
        FixedCostTemplateEntity(
          name: name,
          amount: amount,
          category: category,
          categoryId: categoryId,
          categoryType: categoryType,
          isActive: isActive,
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

    final updatedFixedCosts = List<FixedCostTemplateEntity>.from(state.fixedCosts)
      ..removeAt(index);

    emit(state.copyWith(fixedCosts: updatedFixedCosts));
  }

  void updateFixedCostAt({
    required int index,
    required String name,
    required int amount,
    required String category,
    required int categoryId,
    CategoryType categoryType = CategoryType.system,
    bool isActive = true,
    required FinancialCycle cycle,
    required int dueValue,
  }) {
    if (index < 0 || index >= state.fixedCosts.length) {
      return;
    }

    final updatedFixedCosts = List<FixedCostTemplateEntity>.from(state.fixedCosts)
      ..[index] = FixedCostTemplateEntity(
        name: name,
        amount: amount,
        category: category,
        categoryId: categoryId,
        categoryType: categoryType,
        isActive: isActive,
        cycle: cycle,
        dueValue: dueValue,
      );

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
      safetyFlooring: state.safetyFlooring,
      fixedCosts: state.fixedCosts,
    );
  }
}
