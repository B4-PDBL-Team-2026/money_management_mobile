import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_history_cubit.dart';

import 'register_state.dart';

@Injectable()
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  final SessionCubit sessionCubit;
  final CategoryCubit categoryCubit;
  final TransactionHistoryCubit transactionHistoryCubit;

  RegisterCubit(
    this.registerUseCase,
    this.sessionCubit,
    this.categoryCubit,
    this.transactionHistoryCubit,
  ) : super(RegisterInitial());

  Future<void> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    emit(RegisterLoading());

    try {
      final (user, token, requiresOnboarding) = await registerUseCase.execute(
        name,
        email,
        password,
        passwordConfirmation,
      );

      sessionCubit.authenticate(
        user: user,
        token: token,
        requiresOnboarding: requiresOnboarding,
      );
      categoryCubit.fetchCategories();
      transactionHistoryCubit.getFreshTransactionHistory();

      emit(RegisterSuccess(requiresOnboarding: requiresOnboarding));
    } on ServerException catch (e) {
      emit(RegisterError(e.message));
    } on NetworkException catch (e) {
      emit(RegisterError(e.message));
    } on ValidationException catch (e) {
      emit(RegisterValidationError(e.fieldErrors));
    } on UnexpectedException catch (e) {
      emit(RegisterError(e.message));
    } catch (e) {
      if (kDebugMode) {
        emit(RegisterError('Terjadi kesalahan: ${e.toString()}'));
      } else {
        emit(
          RegisterError(
            'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
    }
  }
}
