import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;

  final _log = Logger('EmailVerificationCubit');

  EmailVerificationCubit(this.sendPasswordResetEmailUseCase)
    : super(EmailVerificationInitial());

  Future<void> sendVerificationEmail({required String email}) async {
    emit(EmailVerificationLoading());

    try {
      final message = await sendPasswordResetEmailUseCase.execute(email: email);
      emit(EmailVerificationSuccess(message));
    } on ServerException catch (e) {
      _log.severe('Server error while sending verification email', e);
      emit(EmailVerificationError(e.message));
    } on NetworkException catch (e) {
      _log.severe('Network error while sending verification email', e);
      emit(EmailVerificationError(e.message));
    } on UnexpectedException catch (e) {
      _log.severe('Unexpected error while sending verification email', e);
      emit(EmailVerificationError(e.message));
    } catch (e) {
      _log.severe('Unhandled error while sending verification email', e);
      if (kDebugMode) {
        emit(EmailVerificationError('Terjadi kesalahan: ${e.toString()}'));
      } else {
        emit(
          EmailVerificationError(
            'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
    }
  }
}
