import 'package:money_management_mobile/features/dashboard/data/data_sources/remote/dashboard_remote_data_source.dart';
import 'package:money_management_mobile/features/dashboard/domain/entities/budget_snapshot_entity.dart';
import 'package:money_management_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<BudgetSnapshotEntity> getBudgetSnapshot() {
    return remoteDataSource.fetchBudgetSnapshot();
  }
}
