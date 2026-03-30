import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_occurrence_entity.dart';

sealed class FixedCostOccurrencesState {
  const FixedCostOccurrencesState();
}

final class FixedCostOccurrencesInitial extends FixedCostOccurrencesState {}

final class FixedCostOccurrencesLoading extends FixedCostOccurrencesState {}

final class FixedCostOccurrencesSuccess extends FixedCostOccurrencesState {
  final List<FixedCostOccurrenceEntity> items;

  const FixedCostOccurrencesSuccess(this.items);
}

final class FixedCostOccurrencesError extends FixedCostOccurrencesState {
  final String message;

  const FixedCostOccurrencesError(this.message);
}
