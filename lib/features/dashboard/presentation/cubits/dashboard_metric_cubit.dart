import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:money_management_mobile/features/dashboard/domain/usecases/calculate_dashboard_metrics_usecase.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_state.dart';

@LazySingleton()
class DashboardMetricCubit extends Cubit<DashboardMetricState> {
  final DashboardRepository _dashboardRepository;
  final CalculateDashboardMetricsUsecase _calculateDashboardMetricsUsecase;
  final EventBus _eventBus;
  late final List<StreamSubscription<dynamic>> _refreshSubscription;
  final _log = Logger('DashboardMetricCubit');

  DashboardMetricCubit(
    this._calculateDashboardMetricsUsecase,
    this._dashboardRepository,
    this._eventBus,
  ) : super(DashboardMetricInitial()) {
    _refreshSubscription = [
      _eventBus.on<FixedCostTemplateChangesEvent>().listen(
        (_) => fetchDashboardMetrics(),
      ),
      _eventBus.on<FixedCostOccurrencesChangesEvent>().listen(
        (_) => fetchDashboardMetrics(),
      ),
      _eventBus.on<TransactionChangesEvent>().listen(
        (_) => fetchDashboardMetrics(),
      ),
    ];
  }

  @override
  Future<void> close() {
    for (var subscription in _refreshSubscription) {
      subscription.cancel();
    }

    return super.close();
  }

  Future<void> fetchDashboardMetrics() async {
    emit(DashboardMetricLoading());

    try {
      final metricsResult = await _calculateDashboardMetricsUsecase.execute();
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
      await _dashboardRepository.confirmFixedCostOccurrence(occurrenceId);
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
      await _dashboardRepository.cancelFixedCostOccurrence(occurrenceId);
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
