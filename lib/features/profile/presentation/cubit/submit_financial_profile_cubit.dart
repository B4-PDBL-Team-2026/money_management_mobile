import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/submit_financial_profile_usecase.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/fixed_cost_occurrences_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/submit_financial_profile_state.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_history_cubit.dart';

@Injectable()
class SubmitFinancialProfileCubit extends Cubit<SubmitFinancialProfileState> {
  final SubmitFinancialProfileUseCase submitOnboardingUseCase;

  final SessionCubit sessionCubit;
  final FixedCostOccurrencesCubit fixedCostOccurrencesCubit;
  final TransactionHistoryCubit transactionHistoryCubit;

  final _log = Logger('SubmitFinancialProfileCubit');

  SubmitFinancialProfileCubit(
    this.submitOnboardingUseCase,
    this.sessionCubit,
    this.fixedCostOccurrencesCubit,
    this.transactionHistoryCubit,
  ) : super(SubmitFinancialProfileInitial());

  void reset() {
    emit(SubmitFinancialProfileInitial());
  }

  Future<void> submit(FinancialProfileEntity financialProfile) async {
    emit(SubmitFinancialProfileLoading());

    try {
      await submitOnboardingUseCase.execute(financialProfile);
      await sessionCubit.markOnboardingAsDone();
      await fixedCostOccurrencesCubit.fetchFixedCostOccurrences(
        forceRefresh: true,
      );
      await transactionHistoryCubit.getFreshTransactionHistory();

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
