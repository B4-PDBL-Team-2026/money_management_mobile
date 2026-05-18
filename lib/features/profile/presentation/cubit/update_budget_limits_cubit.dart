import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_messages.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/update_budget_limits_state.dart';

@injectable
class UpdateBudgetLimitsCubit extends Cubit<UpdateBudgetLimitsState> {
  final ProfileRepository _profileRepository;
  final EventBus _eventBus;
  final _log = Logger('UpdateBudgetLimitsCubit');

  UpdateBudgetLimitsCubit(
    this._profileRepository,
    this._eventBus,
  ) : super(const UpdateBudgetLimitsInitial());

  void reset() {
    emit(const UpdateBudgetLimitsInitial());
  }

  Future<void> updateLimits({
    required int safetyCeiling,
    required int safetyFlooring,
  }) async {
    emit(const UpdateBudgetLimitsLoading());

    try {
      await _profileRepository.updateBudgetLimits(
        safetyCeiling: safetyCeiling,
        safetyFlooring: safetyFlooring,
      );

      // Kirim event agar Dashboard re-fetch data secara real-time
      _eventBus.fire(const BudgetLimitsChangesEvent());

      emit(const UpdateBudgetLimitsSuccess());
    } on ServerException catch (e) {
      emit(UpdateBudgetLimitsFailure(e.message));
    } on NetworkException catch (e) {
      emit(UpdateBudgetLimitsFailure(e.message));
    } on ValidationException catch (e) {
      emit(UpdateBudgetLimitsFailure(e.message));
    } on UnexpectedException catch (e) {
      emit(UpdateBudgetLimitsFailure(e.message));
    } catch (e) {
      _log.severe('Unexpected error during budget limits update', e);
      emit(const UpdateBudgetLimitsFailure(AppMessages.unknownError));
    }
  }
}
