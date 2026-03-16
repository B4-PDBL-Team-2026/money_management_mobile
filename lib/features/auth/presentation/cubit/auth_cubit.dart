import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/login_usecase.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final _log = Logger('AuthCubit');

  AuthCubit(this.loginUseCase) : super(AuthInitial());

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
