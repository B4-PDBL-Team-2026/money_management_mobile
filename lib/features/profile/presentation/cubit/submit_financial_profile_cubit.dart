import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/submit_financial_profile_state.dart';

@Injectable()
class SubmitFinancialProfileCubit extends Cubit<SubmitFinancialProfileState> {
  final ProfileRepository _profileRepository;

  final SessionCubit sessionCubit;
  final EventBus _eventBus;

  final _log = Logger('SubmitFinancialProfileCubit');

  SubmitFinancialProfileCubit(
    this._profileRepository,
    this.sessionCubit,
    this._eventBus,
  ) : super(SubmitFinancialProfileInitial());

  void reset() {
    emit(SubmitFinancialProfileInitial());
  }

  Future<void> submit(FinancialProfileEntity financialProfile) async {
    emit(SubmitFinancialProfileLoading());

    try {
      await _profileRepository.submitFinancialProfile(financialProfile);
      await sessionCubit.markOnboardingAsDone();
      _eventBus.fire(const TransactionChangesEvent());
      _eventBus.fire(const FixedCostTemplateChangesEvent());
      _eventBus.fire(const FixedCostOccurrencesChangesEvent());

      emit(SubmitFinancialProfileSuccess());
    } on ServerException catch (e) {
      emit(SubmitFinancialProfileFailure(e.message));
    } on NetworkException catch (e) {
      emit(SubmitFinancialProfileFailure(e.message));
    } on ValidationException catch (e) {
      emit(SubmitFinancialProfileFailure(e.toString()));
    } on UnexpectedException catch (e) {
      emit(SubmitFinancialProfileFailure(e.message));
    } catch (e) {
      _log.severe('Financial profile submit failed with unknown error', e);
      emit(SubmitFinancialProfileFailure('Terjadi kesalahan: ${e.toString()}'));
    }
  }
}
