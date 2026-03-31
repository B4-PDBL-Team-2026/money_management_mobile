import 'package:money_management_mobile/features/dashboard/domain/entities/unpaid_fixed_cost_entity.dart';

sealed class UnpaidFixedCostOccurrencesState {}

class UnpaidFixedCostOccurrencesInitial
    extends UnpaidFixedCostOccurrencesState {}

class UnpaidFixedCostOccurrencesLoading
    extends UnpaidFixedCostOccurrencesState {}

class UnpaidFixedCostOccurrencesLoaded extends UnpaidFixedCostOccurrencesState {
  final List<UnpaidFixedCostEntity> items;

  UnpaidFixedCostOccurrencesLoaded(this.items);
}

class UnpaidFixedCostOccurrencesError extends UnpaidFixedCostOccurrencesState {
  final String message;

  UnpaidFixedCostOccurrencesError(this.message);
}
