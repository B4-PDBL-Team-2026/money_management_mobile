import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_messages.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';

import 'login_state.dart';

@Injectable()
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;

  final SessionCubit sessionCubit;
  final EventBus _eventBus;

  final _log = Logger('LoginCubit');

  LoginCubit(
    this.loginUseCase,
    this.loginWithGoogleUseCase,
    this.sessionCubit,
    this._eventBus,
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
      _eventBus.fire(const RefreshCategoriesEvent());
      _eventBus.fire(const TransactionChangesEvent());
      _eventBus.fire(const FixedCostTemplateChangesEvent());
      _eventBus.fire(const FixedCostOccurrencesChangesEvent());
      emit(LoginSuccess(requiresOnboarding: requiresOnboarding));
    } on ServerException catch (e) {
      emit(LoginError(e.message));
    } on NetworkException catch (e) {
      emit(LoginError(e.message));
    } on ValidationException catch (e) {
      final fieldErrors = e.fieldErrors;
      if (fieldErrors != null && fieldErrors.isNotEmpty) {
        emit(LoginValidationError(fieldErrors));
      } else {
        emit(LoginError(e.message));
      }
    } on UnexpectedException catch (e) {
      emit(LoginError(e.message));
    } catch (e) {
      if (kDebugMode) {
            emit(LoginError('Ada kendala: ${e.toString()}'));
      } else {
            emit(LoginError(AppMessages.unknownError));
      }
    }
  }

  Future<void> loginWithGoogle() async {
    _log.info('Google Sign-In initiated');
    emit(LoginLoading());

    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        _log.severe('Google Sign-In failed: idToken is null');
        emit(LoginError('Tidak bisa mendapatkan ID Token dari Google.'));
        return;
      }

      final (user, token, requiresOnboarding) =
          await loginWithGoogleUseCase.execute(idToken);

      sessionCubit.authenticate(
        user: user,
        token: token,
        requiresOnboarding: requiresOnboarding,
      );
      _eventBus.fire(const RefreshCategoriesEvent());
      _eventBus.fire(const TransactionChangesEvent());
      _eventBus.fire(const FixedCostTemplateChangesEvent());
      _eventBus.fire(const FixedCostOccurrencesChangesEvent());
      emit(LoginSuccess(requiresOnboarding: requiresOnboarding));
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        _log.info('Google Sign-In cancelled by user');
        emit(LoginInitial());
      } else {
        _log.severe('Google Sign-In failed: ${e.toString()}');
        emit(LoginError('Google Sign-In gagal: ${e.description ?? e.toString()}'));
      }
    } on ServerException catch (e) {
      emit(LoginError(e.message));
    } on NetworkException catch (e) {
      emit(LoginError(e.message));
    } on ValidationException catch (e) {
      final fieldErrors = e.fieldErrors;
      if (fieldErrors != null && fieldErrors.isNotEmpty) {
        emit(LoginValidationError(fieldErrors));
      } else {
        emit(LoginError(e.message));
      }
    } on UnexpectedException catch (e) {
      emit(LoginError(e.message));
    } catch (e) {
      _log.severe('Unexpected Google login error', e);
      if (kDebugMode) {
        emit(LoginError('Ada kendala: ${e.toString()}'));
      } else {
        emit(LoginError(AppMessages.unknownError));
      }
    }
  }
}
