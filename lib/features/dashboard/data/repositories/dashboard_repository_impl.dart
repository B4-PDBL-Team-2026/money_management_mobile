import 'package:money_management_mobile/features/dashboard/data/data_sources/remote/dashboard_remote_data_source.dart';
import 'package:money_management_mobile/features/dashboard/domain/entities/budget_snapshot_entity.dart';
import 'package:money_management_mobile/features/dashboard/domain/entities/unpaid_fixed_cost_entity.dart';
import 'package:money_management_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<BudgetSnapshotEntity> getBudgetSnapshot() async {
    final budgetSnapshotModel = await remoteDataSource.fetchBudgetSnapshot();
    return budgetSnapshotModel.toEntity();
  }

  @override
  Future<List<UnpaidFixedCostEntity>> getUnpaidFixedCostOccurrences() async {
    final models = await remoteDataSource.fetchUnpaidFixedCostOccurrences();
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<void> confirmFixedCostOccurrence(int occurrenceId) async {
    await remoteDataSource.confirmFixedCostOccurrence(occurrenceId);
  }

  @override
  Future<void> cancelFixedCostOccurrence(int occurrenceId) async {
    await remoteDataSource.cancelFixedCostOccurrence(occurrenceId);
  }
}
