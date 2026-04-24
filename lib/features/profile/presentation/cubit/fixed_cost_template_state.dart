import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_occurrence_entity.dart';

sealed class FixedCostTemplateState {
  const FixedCostTemplateState();
}

final class FixedCostTemplateInitial extends FixedCostTemplateState {}

final class FixedCostTemplateLoading extends FixedCostTemplateState {}

final class FixedCostTemplateSuccess extends FixedCostTemplateState {
  final List<FixedCostOccurrenceEntity> items;

  const FixedCostTemplateSuccess(this.items);
}

final class FixedCostTemplateError extends FixedCostTemplateState {
  final String message;

  const FixedCostTemplateError(this.message);
}
