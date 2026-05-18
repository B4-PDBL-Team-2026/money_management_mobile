sealed class UpdateBudgetLimitsState {
  const UpdateBudgetLimitsState();
}

class UpdateBudgetLimitsInitial extends UpdateBudgetLimitsState {
  const UpdateBudgetLimitsInitial();
}

class UpdateBudgetLimitsLoading extends UpdateBudgetLimitsState {
  const UpdateBudgetLimitsLoading();
}

class UpdateBudgetLimitsSuccess extends UpdateBudgetLimitsState {
  const UpdateBudgetLimitsSuccess();
}

class UpdateBudgetLimitsFailure extends UpdateBudgetLimitsState {
  final String message;
  const UpdateBudgetLimitsFailure(this.message);
}
