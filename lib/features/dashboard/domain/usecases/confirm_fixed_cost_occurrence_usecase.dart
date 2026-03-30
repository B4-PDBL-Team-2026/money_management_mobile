import 'package:money_management_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';

class ConfirmFixedCostOccurrenceUseCase {
  final DashboardRepository repository;

  ConfirmFixedCostOccurrenceUseCase(this.repository);

  Future<void> execute(int occurrenceId) {
    return repository.confirmFixedCostOccurrence(occurrenceId);
  }
}
