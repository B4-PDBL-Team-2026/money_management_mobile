import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/core/constants/app_messages.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';

import 'register_state.dart';

@Injectable()
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;

  final SessionCubit sessionCubit;
  final EventBus _eventBus;

  RegisterCubit(
    this.registerUseCase,
    this.loginWithGoogleUseCase,
    this.sessionCubit,
    this._eventBus,
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
      _eventBus.fire(const RefreshCategoriesEvent());

      emit(RegisterSuccess(requiresOnboarding: requiresOnboarding));
    } on ServerException catch (e) {
      emit(RegisterError(e.message));
    } on NetworkException catch (e) {
      emit(RegisterError(e.message));
    } on ValidationException catch (e) {
      final fieldErrors = e.fieldErrors;
      if (fieldErrors != null && fieldErrors.isNotEmpty) {
        emit(RegisterValidationError(fieldErrors));
      } else {
        emit(RegisterError(e.message));
      }
    } on UnexpectedException catch (e) {
      emit(RegisterError(e.message));
    } catch (e) {
      if (kDebugMode) {
        emit(RegisterError('Ada kendala: ${e.toString()}'));
      } else {
        emit(RegisterError(AppMessages.unknownError));
      }
    }
  }

  Future<void> loginWithGoogle() async {
    emit(RegisterLoading());

    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        emit(RegisterError('Tidak bisa mendapatkan ID Token dari Google.'));
        return;
      }

      final (user, token, requiresOnboarding) = await loginWithGoogleUseCase
          .execute(idToken);

      sessionCubit.authenticate(
        user: user,
        token: token,
        requiresOnboarding: requiresOnboarding,
      );
      _eventBus.fire(const RefreshCategoriesEvent());

      emit(RegisterSuccess(requiresOnboarding: requiresOnboarding));
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        emit(RegisterInitial());
      } else {
        emit(
          RegisterError(
            'Google Sign-In gagal: ${e.description ?? e.toString()}',
          ),
        );
      }
    } on ServerException catch (e) {
      emit(RegisterError(e.message));
    } on NetworkException catch (e) {
      emit(RegisterError(e.message));
    } on ValidationException catch (e) {
      final fieldErrors = e.fieldErrors;
      if (fieldErrors != null && fieldErrors.isNotEmpty) {
        emit(RegisterValidationError(fieldErrors));
      } else {
        emit(RegisterError(e.message));
      }
    } on UnexpectedException catch (e) {
      emit(RegisterError(e.message));
    } catch (e) {
      if (kDebugMode) {
        emit(RegisterError('Ada kendala: ${e.toString()}'));
      } else {
        emit(RegisterError(AppMessages.unknownError));
      }
    }
  }
}
