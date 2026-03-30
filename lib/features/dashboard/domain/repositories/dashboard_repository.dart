import 'package:money_management_mobile/features/dashboard/domain/entities/budget_snapshot_entity.dart';

abstract class DashboardRepository {
  Future<BudgetSnapshotEntity> getBudgetSnapshot();

  Future<void> confirmFixedCostOccurrence(int occurrenceId);

  Future<void> cancelFixedCostOccurrence(int occurrenceId);
}
