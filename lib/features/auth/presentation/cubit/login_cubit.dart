import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final SessionCubit sessionCubit;
  final _log = Logger('LoginCubit');

  LoginCubit(this.loginUseCase, this.sessionCubit) : super(LoginInitial());

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

      _log.info('Login completed successfully for user: ${user.email}');
      emit(LoginSuccess(requiresOnboarding: requiresOnboarding));
    } on ServerException catch (e) {
      _log.severe('Login failed with ServerException: ${e.message}', e);
      emit(LoginError(e.message));
    } on NetworkException catch (e) {
      _log.warning('Login failed with NetworkException: ${e.message}', e);
      emit(LoginError(e.message));
    } on UnexpectedException catch (e) {
      _log.severe('Login failed with UnexpectedException: ${e.message}', e);
      emit(LoginError(e.message));
    } catch (e) {
      _log.severe('Login failed with unexpected error', e);
      emit(LoginError("Terjadi kesalahan: ${e.toString()}"));
    }
  }
}
