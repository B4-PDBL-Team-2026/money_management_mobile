sealed class SubmitFinancialProfileState {
  const SubmitFinancialProfileState();
}

final class SubmitFinancialProfileInitial extends SubmitFinancialProfileState {}

final class SubmitFinancialProfileLoading extends SubmitFinancialProfileState {}

final class SubmitFinancialProfileSuccess extends SubmitFinancialProfileState {}

final class SubmitFinancialProfileFailure extends SubmitFinancialProfileState {
  final String message;

  const SubmitFinancialProfileFailure(this.message);
}
