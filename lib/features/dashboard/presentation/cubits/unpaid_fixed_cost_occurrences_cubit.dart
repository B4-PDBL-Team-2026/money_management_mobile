import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/unpaid_fixed_cost_occurrences_state.dart';
import 'package:event_bus/event_bus.dart';

@LazySingleton()
class UnpaidFixedCostOccurrencesCubit
    extends Cubit<UnpaidFixedCostOccurrencesState> {
  final DashboardRepository _dashboardRepository;
  final EventBus _eventBus;
  late final StreamSubscription<dynamic> _refreshSubscription;

  final _log = Logger('UnpaidFixedCostOccurrencesCubit');

  UnpaidFixedCostOccurrencesCubit(this._eventBus, this._dashboardRepository)
    : super(UnpaidFixedCostOccurrencesInitial()) {
    _refreshSubscription = _eventBus.on<FixedCostTemplateChangesEvent>().listen(
      (_) => fetchUnpaidFixedCosts(),
    );
  }

  Future<void> fetchUnpaidFixedCosts() async {
    emit(UnpaidFixedCostOccurrencesLoading());

    try {
      final items = await _dashboardRepository.getUnpaidFixedCostOccurrences();
      emit(UnpaidFixedCostOccurrencesLoaded(items));
    } on ServerException catch (e) {
      _log.severe('Error fetching unpaid fixed cost occurrences', e);
      emit(UnpaidFixedCostOccurrencesError(e.message));
    } on NetworkException catch (e) {
      _log.severe('Error fetching unpaid fixed cost occurrences', e);
      emit(UnpaidFixedCostOccurrencesError(e.message));
    } on UnexpectedException catch (e) {
      _log.severe('Error fetching unpaid fixed cost occurrences', e);
      emit(UnpaidFixedCostOccurrencesError(e.message));
    } catch (e) {
      _log.severe('Error fetching unpaid fixed cost occurrences', e);
      if (kDebugMode) {
        emit(
          UnpaidFixedCostOccurrencesError('Terjadi kesalahan: ${e.toString()}'),
        );
      } else {
        emit(
          UnpaidFixedCostOccurrencesError(
            'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
    }
  }

  Future<bool> confirmFixedCostOccurrence(int occurrenceId) async {
    try {
      await _dashboardRepository.confirmFixedCostOccurrence(occurrenceId);
      await fetchUnpaidFixedCosts();
      _eventBus.fire(const TransactionChangesEvent());
      return true;
    } on ServerException catch (e) {
      _log.severe('Error confirming fixed cost occurrence', e);
      emit(UnpaidFixedCostOccurrencesError(e.message));
      return false;
    } on NetworkException catch (e) {
      _log.severe('Error confirming fixed cost occurrence', e);
      emit(UnpaidFixedCostOccurrencesError(e.message));
      return false;
    } on UnexpectedException catch (e) {
      _log.severe('Error confirming fixed cost occurrence', e);
      emit(UnpaidFixedCostOccurrencesError(e.message));
      return false;
    } catch (e) {
      _log.severe('Error confirming fixed cost occurrence', e);
      if (kDebugMode) {
        emit(
          UnpaidFixedCostOccurrencesError('Terjadi kesalahan: ${e.toString()}'),
        );
      } else {
        emit(
          UnpaidFixedCostOccurrencesError(
            'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
      return false;
    }
  }

  Future<bool> cancelFixedCostOccurrence(int occurrenceId) async {
    try {
      await _dashboardRepository.cancelFixedCostOccurrence(occurrenceId);
      await fetchUnpaidFixedCosts();
      _eventBus.fire(const TransactionChangesEvent());
      return true;
    } on ServerException catch (e) {
      _log.severe('Error cancelling fixed cost occurrence', e);
      emit(UnpaidFixedCostOccurrencesError(e.message));
      return false;
    } on NetworkException catch (e) {
      _log.severe('Error cancelling fixed cost occurrence', e);
      emit(UnpaidFixedCostOccurrencesError(e.message));
      return false;
    } on UnexpectedException catch (e) {
      _log.severe('Error cancelling fixed cost occurrence', e);
      emit(UnpaidFixedCostOccurrencesError(e.message));
      return false;
    } catch (e) {
      _log.severe('Error cancelling fixed cost occurrence', e);
      if (kDebugMode) {
        emit(
          UnpaidFixedCostOccurrencesError('Terjadi kesalahan: ${e.toString()}'),
        );
      } else {
        emit(
          UnpaidFixedCostOccurrencesError(
            'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
      return false;
    }
  }

  @override
  Future<void> close() {
    _refreshSubscription.cancel();
    return super.close();
  }
}
