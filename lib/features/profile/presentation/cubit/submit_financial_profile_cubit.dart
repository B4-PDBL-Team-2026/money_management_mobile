import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/complete_onboarding_usecase.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/submit_onboarding_usecase.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/submit_financial_profile_state.dart';

class SubmitFinancialProfileCubit extends Cubit<SubmitFinancialProfileState> {
  final SubmitOnboardingUseCase submitOnboardingUseCase;
  final CompleteOnboardingUseCase completeOnboardingUseCase;
  final SessionCubit sessionCubit;
  final _log = Logger('SubmitFinancialProfileCubit');

  SubmitFinancialProfileCubit(
    this.submitOnboardingUseCase,
    this.completeOnboardingUseCase,
    this.sessionCubit,
  ) : super(SubmitFinancialProfileInitial());

  void reset() {
    emit(SubmitFinancialProfileInitial());
  }

  Future<void> submit(FinancialProfileEntity financialProfile) async {
    if (financialProfile.initialBalance <= 0) {
      emit(SubmitFinancialProfileFailure('Nominal saldo awal wajib diisi'));
      return;
    }

    emit(SubmitFinancialProfileLoading());

    try {
      await submitOnboardingUseCase.execute(financialProfile);

      final (user, token) = await completeOnboardingUseCase.execute();

      sessionCubit.authenticate(
        user: user,
        token: token,
        requiresOnboarding: false,
      );

      emit(SubmitFinancialProfileSuccess());
    } on ServerException catch (e) {
      _log.warning(
        'Financial profile submit failed with server error: ${e.message}',
        e,
      );
      emit(SubmitFinancialProfileFailure(e.message));
    } on NetworkException catch (e) {
      _log.warning(
        'Financial profile submit failed with network error: ${e.message}',
        e,
      );
      emit(SubmitFinancialProfileFailure(e.message));
    } on UnexpectedException catch (e) {
      _log.severe(
        'Financial profile submit failed with unexpected exception: ${e.message}',
        e,
      );
      emit(SubmitFinancialProfileFailure(e.message));
    } catch (e) {
      _log.severe('Financial profile submit failed with unknown error', e);
      emit(SubmitFinancialProfileFailure('Terjadi kesalahan: ${e.toString()}'));
    }
  }
}
