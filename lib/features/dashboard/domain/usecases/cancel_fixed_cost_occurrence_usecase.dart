import 'package:money_management_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';

class CancelFixedCostOccurrenceUseCase {
  final DashboardRepository repository;

  CancelFixedCostOccurrenceUseCase(this.repository);

  Future<void> execute(int occurrenceId) {
    return repository.cancelFixedCostOccurrence(occurrenceId);
  }
}
