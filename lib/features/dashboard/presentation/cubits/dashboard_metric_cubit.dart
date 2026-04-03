import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/dashboard/domain/usecases/calculate_dashboard_metrics_usecase.dart';
import 'package:money_management_mobile/features/dashboard/domain/usecases/cancel_fixed_cost_occurrence_usecase.dart';
import 'package:money_management_mobile/features/dashboard/domain/usecases/confirm_fixed_cost_occurrence_usecase.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_state.dart';

@LazySingleton()
class DashboardMetricCubit extends Cubit<DashboardMetricState> {
  final CalculateDashboardMetricsUsecase calculateDashboardMetricsUsecase;
  final ConfirmFixedCostOccurrenceUseCase confirmFixedCostOccurrenceUseCase;
  final CancelFixedCostOccurrenceUseCase cancelFixedCostOccurrenceUseCase;

  final _log = Logger('DashboardMetricCubit');

  DashboardMetricCubit(
    this.calculateDashboardMetricsUsecase,
    this.confirmFixedCostOccurrenceUseCase,
    this.cancelFixedCostOccurrenceUseCase,
  ) : super(DashboardMetricInitial());

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

  Future<void> confirmFixedCostOccurrence(int occurrenceId) async {
    try {
      await confirmFixedCostOccurrenceUseCase.execute(occurrenceId);
      await fetchDashboardMetrics();
    } on ServerException catch (e) {
      _log.severe('Error confirming fixed cost occurrence', e);
      emit(DashboardMetricError(message: e.message));
    } on NetworkException catch (e) {
      _log.severe('Error confirming fixed cost occurrence', e);
      emit(DashboardMetricError(message: e.message));
    } on UnexpectedException catch (e) {
      _log.severe('Error confirming fixed cost occurrence', e);
      emit(DashboardMetricError(message: e.message));
    } catch (e) {
      _log.severe('Error confirming fixed cost occurrence', e);
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

  Future<void> cancelFixedCostOccurrence(int occurrenceId) async {
    try {
      await cancelFixedCostOccurrenceUseCase.execute(occurrenceId);
      await fetchDashboardMetrics();
    } on ServerException catch (e) {
      _log.severe('Error cancelling fixed cost occurrence', e);
      emit(DashboardMetricError(message: e.message));
    } on NetworkException catch (e) {
      _log.severe('Error cancelling fixed cost occurrence', e);
      emit(DashboardMetricError(message: e.message));
    } on UnexpectedException catch (e) {
      _log.severe('Error cancelling fixed cost occurrence', e);
      emit(DashboardMetricError(message: e.message));
    } catch (e) {
      _log.severe('Error cancelling fixed cost occurrence', e);
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
