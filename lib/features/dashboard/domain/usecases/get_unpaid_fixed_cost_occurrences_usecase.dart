import 'package:money_management_mobile/features/dashboard/domain/entities/unpaid_fixed_cost_entity.dart';
import 'package:money_management_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetUnpaidFixedCostOccurrencesUseCase {
  final DashboardRepository repository;

  GetUnpaidFixedCostOccurrencesUseCase(this.repository);

  Future<List<UnpaidFixedCostEntity>> execute() {
    return repository.getUnpaidFixedCostOccurrences();
  }
}
