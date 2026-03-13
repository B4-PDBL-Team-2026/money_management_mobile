import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/register_usecase.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final _log = Logger('AuthCubit');

  AuthCubit(this.registerUseCase, this.loginUseCase) : super(AuthInitial());

  Future<void> register(String name, String email, String password) async {
    _log.info('Register initiated for email: $email');
    emit(AuthLoading());

    try {
      await registerUseCase.execute(name, email, password);
      _log.info('Register completed successfully');
      emit(AuthRegisterSuccess());
    } on ServerException catch (e) {
      _log.severe('Register failed with ServerException: ${e.message}', e);
      emit(AuthError(e.message));
    } on NetworkException catch (e) {
      _log.warning('Register failed with NetworkException: ${e.message}', e);
      emit(AuthError(e.message));
    } on UnexpectedException catch (e) {
      _log.severe('Register failed with UnexpectedException: ${e.message}', e);
      emit(AuthError(e.message));
    } catch (e) {
      _log.severe('Register failed with unexpected error', e);
      emit(AuthError("Terjadi kesalahan: ${e.toString()}"));
    }
  }

  Future<void> login(String email, String password) async {
    _log.info('Login initiated for email: $email');
    emit(AuthLoading());

    try {
      final (user, token) = await loginUseCase.execute(email, password);
      _log.info('Login completed successfully for user: ${user.email}');
      emit(AuthLoginSuccess(user: user, token: token));
    } on ServerException catch (e) {
      _log.severe('Login failed with ServerException: ${e.message}', e);
      emit(AuthError(e.message));
    } on NetworkException catch (e) {
      _log.warning('Login failed with NetworkException: ${e.message}', e);
      emit(AuthError(e.message));
    } on UnexpectedException catch (e) {
      _log.severe('Login failed with UnexpectedException: ${e.message}', e);
      emit(AuthError(e.message));
    } catch (e) {
      _log.severe('Login failed with unexpected error', e);
      emit(AuthError("Terjadi kesalahan: ${e.toString()}"));
    }
  }
}
