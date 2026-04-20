import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_template_entity.dart';

class FinancialProfileDraftState {
  final FinancialCycle budgetCycle;
  final int initialBalance;
  final int safetyCeiling;
  final int safetyFlooring;
  final List<FixedCostTemplateEntity> fixedCosts;

  const FinancialProfileDraftState({
    required this.budgetCycle,
    required this.initialBalance,
    required this.safetyCeiling,
    required this.safetyFlooring,
    required this.fixedCosts,
  });

  factory FinancialProfileDraftState.initial() {
    return const FinancialProfileDraftState(
      budgetCycle: FinancialCycle.monthly,
      initialBalance: 0,
      safetyCeiling: 0,
      safetyFlooring: 0,
      fixedCosts: [],
    );
  }

  FinancialProfileDraftState copyWith({
    FinancialCycle? budgetCycle,
    int? initialBalance,
    int? safetyCeiling,
    int? safetyFlooring,
    List<FixedCostTemplateEntity>? fixedCosts,
  }) {
    return FinancialProfileDraftState(
      budgetCycle: budgetCycle ?? this.budgetCycle,
      initialBalance: initialBalance ?? this.initialBalance,
      safetyCeiling: safetyCeiling ?? this.safetyCeiling,
      safetyFlooring: safetyFlooring ?? this.safetyFlooring,
      fixedCosts: fixedCosts ?? this.fixedCosts,
    );
  }
}
