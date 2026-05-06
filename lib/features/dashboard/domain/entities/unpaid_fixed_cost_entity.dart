import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

class UnpaidFixedCostTemplateEntity {
  final int occurrenceId;
  final int categoryId;
  final String categoryName;
  final String categoryIcon;
  final String name;
  final int amount;
  final FinancialCycle cycle;
  final DateTime? dueDate;

  const UnpaidFixedCostTemplateEntity({
    required this.occurrenceId,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.name,
    required this.amount,
    required this.cycle,
    this.dueDate,
  });
}
