import 'package:money_management_mobile/features/dashboard/domain/entities/unpaid_fixed_cost_entity.dart';

sealed class UnpaidFixedCostTemplateState {}

class UnpaidFixedCostTemplateInitial
    extends UnpaidFixedCostTemplateState {}

class UnpaidFixedCostTemplateLoading
    extends UnpaidFixedCostTemplateState {}

class UnpaidFixedCostTemplateLoaded extends UnpaidFixedCostTemplateState {
  final List<UnpaidFixedCostTemplateEntity> items;

  UnpaidFixedCostTemplateLoaded(this.items);
}

class UnpaidFixedCostTemplateError extends UnpaidFixedCostTemplateState {
  final String message;

  UnpaidFixedCostTemplateError(this.message);
}
