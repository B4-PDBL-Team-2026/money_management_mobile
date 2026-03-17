import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_entity.dart';

class FinancialProfileDraftState {
  final BudgetCycle budgetCycle;
  final int initialBalance;
  final int safetyCeiling;
  final List<FixedCostEntity> fixedCosts;

  const FinancialProfileDraftState({
    required this.budgetCycle,
    required this.initialBalance,
    required this.safetyCeiling,
    required this.fixedCosts,
  });

  factory FinancialProfileDraftState.initial() {
    return const FinancialProfileDraftState(
      budgetCycle: BudgetCycle.monthly,
      initialBalance: 0,
      safetyCeiling: 0,
      fixedCosts: [],
    );
  }

  FinancialProfileDraftState copyWith({
    BudgetCycle? budgetCycle,
    int? initialBalance,
    int? safetyCeiling,
    List<FixedCostEntity>? fixedCosts,
  }) {
    return FinancialProfileDraftState(
      budgetCycle: budgetCycle ?? this.budgetCycle,
      initialBalance: initialBalance ?? this.initialBalance,
      safetyCeiling: safetyCeiling ?? this.safetyCeiling,
      fixedCosts: fixedCosts ?? this.fixedCosts,
    );
  }
}
