import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/fixed_cost_occurrences_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_history_cubit.dart';

import 'login_state.dart';

@Injectable()
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  final SessionCubit sessionCubit;
  final CategoryCubit categoryCubit;
  final TransactionHistoryCubit transactionHistoryCubit;
  final FixedCostOccurrencesCubit fixedCostOccurrencesCubit;

  final _log = Logger('LoginCubit');

  LoginCubit(
    this.loginUseCase,
    this.sessionCubit,
    this.categoryCubit,
    this.transactionHistoryCubit,
    this.fixedCostOccurrencesCubit,
  ) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    _log.info('Login initiated for email: $email');
    emit(LoginLoading());

    try {
      final (user, token, requiresOnboarding) = await loginUseCase.execute(
        email,
        password,
      );

      sessionCubit.authenticate(
        user: user,
        token: token,
        requiresOnboarding: requiresOnboarding,
      );
      categoryCubit.fetchCategories();
      transactionHistoryCubit.getFreshTransactionHistory();
      fixedCostOccurrencesCubit.fetchFixedCostOccurrences(forceRefresh: true);
      emit(LoginSuccess(requiresOnboarding: requiresOnboarding));
    } on ServerException catch (e) {
      emit(LoginError(e.message));
    } on NetworkException catch (e) {
      emit(LoginError(e.message));
    } on ValidationException catch (e) {
      emit(LoginValidationError(e.fieldErrors));
    } on UnexpectedException catch (e) {
      emit(LoginError(e.message));
    } catch (e) {
      if (kDebugMode) {
        emit(LoginError('Terjadi kesalahan: ${e.toString()}'));
      } else {
        emit(
          LoginError(
            'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
    }
  }
}
