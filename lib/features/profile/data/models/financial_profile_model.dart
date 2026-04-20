import 'package:money_management_mobile/features/profile/data/models/fixed_cost_template_model.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/main.dart';

class FinancialProfileModel extends FinancialProfileEntity {
  const FinancialProfileModel({
    required super.budgetCycle,
    required super.initialBalance,
    required super.safetyCeiling,
    required super.safetyFlooring,
    required super.fixedCosts,
  });

  factory FinancialProfileModel.fromEntity(FinancialProfileEntity entity) {
    return FinancialProfileModel(
      budgetCycle: entity.budgetCycle,
      initialBalance: entity.initialBalance,
      safetyCeiling: entity.safetyCeiling,
      safetyFlooring: entity.safetyFlooring,
      fixedCosts: entity.fixedCosts
          .map(FixedCostTemplateModel.fromEntity)
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'budgetCycle': budgetCycle.value,
      'initialBalance': initialBalance,
      'flooringLimit': safetyFlooring,
      'ceilingLimit': safetyCeiling,
      'timezone': localTimezone.identifier,
      'fixedCosts': fixedCosts
          .map((item) => FixedCostTemplateModel.fromEntity(item).toJson())
          .toList(growable: false),
    };
  }
}
