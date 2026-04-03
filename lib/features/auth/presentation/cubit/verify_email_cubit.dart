import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

import 'verify_email_state.dart';

@Injectable()
class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  final AuthRepository _authRepository;

  final _log = Logger('VerifyEmailCubit');

  VerifyEmailCubit(this._authRepository) : super(VerifyEmailInitial());

  Future<void> requestVerificationEmail() async {
    emit(VerifyEmailLoading());

    try {
      final message = await _authRepository.requestEmailVerification();
      emit(VerifyEmailSuccess(message));
    } on ServerException catch (e) {
      _log.severe('Server error while requesting email verification', e);
      emit(VerifyEmailError(e.message));
    } on NetworkException catch (e) {
      _log.severe('Network error while requesting email verification', e);
      emit(VerifyEmailError(e.message));
    } on UnexpectedException catch (e) {
      _log.severe('Unexpected error while requesting email verification', e);
      emit(VerifyEmailError(e.message));
    } catch (e) {
      _log.severe('Unhandled error while requesting email verification', e);
      if (kDebugMode) {
        _log.severe('Unhandled error type: ${e.runtimeType}');
      }
      emit(
        VerifyEmailError(
          'Terjadi kesalahan saat memproses permintaan verifikasi email',
        ),
      );
    }
  }
}
