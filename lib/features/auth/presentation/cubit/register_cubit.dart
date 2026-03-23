import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';

import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;
  final SessionCubit sessionCubit;
  final _log = Logger('RegisterCubit');

  RegisterCubit(this.registerUseCase, this.sessionCubit)
    : super(RegisterInitial());

  Future<void> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    _log.info('Register initiated for email: $email');
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

      _log.info('Register completed successfully for user: ${user.email}');
      emit(RegisterSuccess(requiresOnboarding: requiresOnboarding));
    } on ServerException catch (e) {
      _log.severe('Register failed with ServerException: ${e.message}', e);
      emit(RegisterError(e.message));
    } on NetworkException catch (e) {
      _log.warning('Register failed with NetworkException: ${e.message}', e);
      emit(RegisterError(e.message));
    } on UnexpectedException catch (e) {
      _log.severe('Register failed with UnexpectedException: ${e.message}', e);
      emit(RegisterError(e.message));
    } catch (e) {
      _log.severe('Register failed with unexpected error', e);
      emit(RegisterError('Terjadi kesalahan: ${e.toString()}'));
    }
  }
}
