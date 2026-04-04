import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/reset_password_state.dart';

@Injectable()
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepository _authRepository;

  final _log = Logger('ResetPasswordCubit');

  ResetPasswordCubit(this._authRepository) : super(ResetPasswordInitial());

  Future<void> sendVerificationEmail({required String email}) async {
    emit(ResetPasswordLoading());

    try {
      final message = await _authRepository.sendPasswordResetEmail(email);
      emit(ResetPasswordSuccess(message));
    } on ServerException catch (e) {
      _log.severe('Server error while sending verification email', e);
      emit(ResetPasswordError(e.message));
    } on NetworkException catch (e) {
      _log.severe('Network error while sending verification email', e);
      emit(ResetPasswordError(e.message));
    } on UnexpectedException catch (e) {
      _log.severe('Unexpected error while sending verification email', e);
      emit(ResetPasswordError(e.message));
    } catch (e) {
      _log.severe('Unhandled error while sending verification email', e);
      if (kDebugMode) {
        emit(ResetPasswordError('Terjadi kesalahan: ${e.toString()}'));
      } else {
        emit(
          ResetPasswordError(
            'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
    }
  }
}
