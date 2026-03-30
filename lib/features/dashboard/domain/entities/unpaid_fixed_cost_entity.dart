import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

class UnpaidFixedCostEntity {
  final int occurrenceId;
  final String name;
  final int amount;
  final FinancialCycle cycle;
  final int dueValue;

  const UnpaidFixedCostEntity({
    required this.occurrenceId,
    required this.name,
    required this.amount,
    required this.cycle,
    required this.dueValue,
  });
}
