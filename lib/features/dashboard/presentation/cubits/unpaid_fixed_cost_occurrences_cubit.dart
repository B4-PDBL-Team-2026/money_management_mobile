import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/dashboard/domain/usecases/cancel_fixed_cost_occurrence_usecase.dart';
import 'package:money_management_mobile/features/dashboard/domain/usecases/confirm_fixed_cost_occurrence_usecase.dart';
import 'package:money_management_mobile/features/dashboard/domain/usecases/get_unpaid_fixed_cost_occurrences_usecase.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/unpaid_fixed_cost_occurrences_state.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_history_cubit.dart';

@LazySingleton()
class UnpaidFixedCostOccurrencesCubit
    extends Cubit<UnpaidFixedCostOccurrencesState> {
  final GetUnpaidFixedCostOccurrencesUseCase
  getUnpaidFixedCostOccurrencesUseCase;
  final ConfirmFixedCostOccurrenceUseCase confirmFixedCostOccurrenceUseCase;
  final CancelFixedCostOccurrenceUseCase cancelFixedCostOccurrenceUseCase;
  final DashboardMetricCubit dashboardMetricCubit;
  final TransactionHistoryCubit transactionHistoryCubit;

  final _log = Logger('UnpaidFixedCostOccurrencesCubit');

  UnpaidFixedCostOccurrencesCubit(
    this.getUnpaidFixedCostOccurrencesUseCase,
    this.confirmFixedCostOccurrenceUseCase,
    this.cancelFixedCostOccurrenceUseCase,
    this.dashboardMetricCubit,
    this.transactionHistoryCubit,
  ) : super(UnpaidFixedCostOccurrencesInitial());

  Future<void> fetchUnpaidFixedCosts() async {
    emit(UnpaidFixedCostOccurrencesLoading());

    try {
      final items = await getUnpaidFixedCostOccurrencesUseCase.execute();
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
      await confirmFixedCostOccurrenceUseCase.execute(occurrenceId);
      await fetchUnpaidFixedCosts();
      await dashboardMetricCubit.fetchDashboardMetrics();
      await transactionHistoryCubit.getFreshTransactionHistory();
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
      await cancelFixedCostOccurrenceUseCase.execute(occurrenceId);
      await fetchUnpaidFixedCosts();
      await dashboardMetricCubit.fetchDashboardMetrics();
      await transactionHistoryCubit.getFreshTransactionHistory();
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
}
