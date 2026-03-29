import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
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
    } on ServerException catch (e) {
      _log.severe('Error fetching dashboard metric', e);
      emit(DashboardMetricError(message: e.message));
    } on NetworkException catch (e) {
      _log.severe('Error fetching dashboard metric', e);
      emit(DashboardMetricError(message: e.message));
    } on UnexpectedException catch (e) {
      _log.severe('Error fetching dashboard metric', e);
      emit(DashboardMetricError(message: e.message));
    } catch (e) {
      _log.severe('Error fetching dashboard metric', e);
      if (kDebugMode) {
        emit(
          DashboardMetricError(message: 'Terjadi kesalahan: ${e.toString()}'),
        );
      } else {
        emit(
          DashboardMetricError(
            message:
                'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
    }
  }
}
