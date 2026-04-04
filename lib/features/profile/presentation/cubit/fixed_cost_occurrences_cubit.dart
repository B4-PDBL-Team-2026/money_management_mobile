import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/unpaid_fixed_cost_occurrences_cubit.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_entity.dart';
import 'package:money_management_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/fixed_cost_occurrences_state.dart';

@LazySingleton()
class FixedCostOccurrencesCubit extends Cubit<FixedCostOccurrencesState> {
  final ProfileRepository _profileRepository;

  final UnpaidFixedCostOccurrencesCubit unpaidFixedCostOccurrencesCubit;
  final DashboardMetricCubit dashboardMetricCubit;

  final _log = Logger('FixedCostOccurrencesCubit');

  FixedCostOccurrencesCubit(
    this._profileRepository,
    this.unpaidFixedCostOccurrencesCubit,
    this.dashboardMetricCubit,
  ) : super(FixedCostOccurrencesInitial());

  Future<void> fetchFixedCostOccurrences({bool forceRefresh = false}) async {
    if (!forceRefresh && state is FixedCostOccurrencesSuccess) {
      return;
    }

    emit(FixedCostOccurrencesLoading());

    try {
      final items = await _profileRepository.getFixedCostOccurrences();
      emit(FixedCostOccurrencesSuccess(items));
    } on ServerException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } on NetworkException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } on UnauthorizedException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } on UnexpectedException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } catch (e) {
      _log.severe('Unexpected error while fetching fixed cost occurrences', e);
      emit(FixedCostOccurrencesError('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  Future<void> createFixedCost(FixedCostEntity payload) async {
    emit(FixedCostOccurrencesLoading());

    try {
      await _profileRepository.createFixedCost(payload);
      await Future.wait([
        fetchFixedCostOccurrences(forceRefresh: true),
        unpaidFixedCostOccurrencesCubit.fetchUnpaidFixedCosts(),
        dashboardMetricCubit.fetchDashboardMetrics(),
      ]);
    } on ServerException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } on NetworkException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } on UnauthorizedException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } on ValidationException catch (e) {
      emit(FixedCostOccurrencesError(e.toString()));
    } on UnexpectedException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } catch (e) {
      _log.severe('Unexpected error while creating fixed cost', e);
      emit(FixedCostOccurrencesError('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  Future<void> deleteFixedCost(int fixedCostTemplateId) async {
    emit(FixedCostOccurrencesLoading());

    try {
      await _profileRepository.deleteFixedCost(fixedCostTemplateId);
      await Future.wait([
        fetchFixedCostOccurrences(forceRefresh: true),
        unpaidFixedCostOccurrencesCubit.fetchUnpaidFixedCosts(),
        dashboardMetricCubit.fetchDashboardMetrics(),
      ]);
    } on ServerException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } on NetworkException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } on UnauthorizedException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } on ValidationException catch (e) {
      emit(FixedCostOccurrencesError(e.toString()));
    } on UnexpectedException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } catch (e) {
      _log.severe('Unexpected error while deleting fixed cost', e);
      emit(FixedCostOccurrencesError('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  Future<void> updateFixedCost(
    int fixedCostTemplateId,
    FixedCostEntity payload,
  ) async {
    emit(FixedCostOccurrencesLoading());

    try {
      await _profileRepository.updateFixedCost(fixedCostTemplateId, payload);
      await Future.wait([
        fetchFixedCostOccurrences(forceRefresh: true),
        unpaidFixedCostOccurrencesCubit.fetchUnpaidFixedCosts(),
        dashboardMetricCubit.fetchDashboardMetrics(),
      ]);
    } on ServerException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } on NetworkException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } on UnauthorizedException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } on ValidationException catch (e) {
      emit(FixedCostOccurrencesError(e.toString()));
    } on UnexpectedException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } catch (e) {
      _log.severe('Unexpected error while updating fixed cost', e);
      emit(FixedCostOccurrencesError('Terjadi kesalahan: ${e.toString()}'));
    }
  }
}
