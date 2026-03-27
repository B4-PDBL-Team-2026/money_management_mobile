import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/features/dashboard/domain/usecases/calculate_dashboard_metrics_usecase.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_state.dart';

class DashboardMetricCubit extends Cubit<DashboardMetricState> {
  CalculateDashboardMetricsUsecase calculateDashboardMetricsUsecase;

  final _log = Logger('DashboardMetricCubit');

  DashboardMetricCubit(this.calculateDashboardMetricsUsecase)
    : super(DashboardMetricInitial());

  Future<void> fetchDashboardMetrics() async {
    emit(DashboardMetricLoading());

    try {
      final metricsResult = await calculateDashboardMetricsUsecase.execute();
      emit(DashboardMetricLoaded(metrics: metricsResult));
    } catch (e) {
      _log.severe('Error fetching dashboard metrics: $e');
      emit(DashboardMetricError(message: e.toString()));
    }
  }
}
