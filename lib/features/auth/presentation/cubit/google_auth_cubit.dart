import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_messages.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';

import 'google_auth_state.dart';

@Injectable()
class GoogleAuthCubit extends Cubit<GoogleAuthState> {
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final SessionCubit sessionCubit;

  final _log = Logger('GoogleAuthCubit');

  GoogleAuthCubit(this.loginWithGoogleUseCase, this.sessionCubit)
    : super(GoogleAuthInitial());

  Future<void> signInWithGoogle() async {
    _log.info('Google Sign-In initiated');
    emit(GoogleAuthLoading());

    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        _log.severe('Google Sign-In failed: idToken is null');
        emit(GoogleAuthError('Tidak bisa mendapatkan ID Token dari Google.'));
        return;
      }

      final (user, token, requiresOnboarding) = await loginWithGoogleUseCase
          .execute(idToken);

      sessionCubit.authenticate(
        user: user,
        token: token,
        requiresOnboarding: requiresOnboarding,
      );
      emit(GoogleAuthSuccess(requiresOnboarding: requiresOnboarding));
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        _log.info('Google Sign-In cancelled by user');
        emit(GoogleAuthInitial());
      } else {
        _log.severe('Google Sign-In failed: ${e.toString()}');
        emit(
          GoogleAuthError(
            'Google Sign-In gagal: ${e.description ?? e.toString()}',
          ),
        );
      }
    } on ServerException catch (e) {
      emit(GoogleAuthError(e.message));
    } on NetworkException catch (e) {
      emit(GoogleAuthError(e.message));
    } on ValidationException catch (e) {
      emit(GoogleAuthError(e.message));
    } on UnexpectedException catch (e) {
      emit(GoogleAuthError(e.message));
    } catch (e) {
      _log.severe('Unexpected Google login error', e);
      if (kDebugMode) {
        emit(GoogleAuthError('Ada kendala: ${e.toString()}'));
      } else {
        emit(GoogleAuthError(AppMessages.unknownError));
      }
    }
  }
}
