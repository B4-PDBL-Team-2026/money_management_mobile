import 'package:money_management_mobile/features/dashboard/domain/usecases/calculate_dashboard_metrics_usecase.dart';

sealed class DashboardMetricState {}

class DashboardMetricInitial extends DashboardMetricState {}

class DashboardMetricLoading extends DashboardMetricState {}

class DashboardMetricLoaded extends DashboardMetricState {
  final DashboardMetricsResult metrics;
  DashboardMetricLoaded({required this.metrics});
}

class DashboardMetricError extends DashboardMetricState {
  final String message;
  DashboardMetricError({required this.message});
}
