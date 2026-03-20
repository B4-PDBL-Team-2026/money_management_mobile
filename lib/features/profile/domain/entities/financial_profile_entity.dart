import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_entity.dart';

enum BudgetCycle { weekly, monthly }

class FinancialProfileEntity {
  final BudgetCycle budgetCycle;
  final int initialBalance;
  final int safetyCeiling;
  final int safetyFlooring;
  final List<FixedCostEntity> fixedCosts;

  const FinancialProfileEntity({
    required this.budgetCycle,
    required this.initialBalance,
    required this.safetyCeiling,
    required this.safetyFlooring,
    required this.fixedCosts,
  });
}
