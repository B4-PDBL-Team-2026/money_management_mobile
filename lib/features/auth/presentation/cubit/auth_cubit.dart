import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SessionCubit sessionCubit;
  final _log = Logger('AuthCubit');

  AuthCubit(this.loginUseCase, this.sessionCubit) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    _log.info('Login initiated for email: $email');
    emit(AuthLoading());

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
      emit(AuthLoginSuccess(requiresOnboarding: requiresOnboarding));
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
