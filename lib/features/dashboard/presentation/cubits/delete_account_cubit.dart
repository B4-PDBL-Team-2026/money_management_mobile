import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/delete_account_state.dart';

@Injectable()
class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final AuthRepository _authRepository;

  final SessionCubit sessionCubit;

  DeleteAccountCubit(this._authRepository, this.sessionCubit)
    : super(DeleteAccountInitial());

  Future<void> deleteAccount(String password) async {
    emit(DeleteAccountLoading());
    try {
      await _authRepository.deleteAccount(password);
      await sessionCubit.logout();

      emit(DeleteAccountSuccess());
    } on ServerException catch (e) {
      emit(DeleteAccountError(e.message));
    } on NetworkException catch (e) {
      emit(DeleteAccountError(e.message));
    } on UnexpectedException catch (e) {
      emit(DeleteAccountError(e.message));
    } on ValidationException catch (e) {
      emit(DeleteAccountValidationError(e.fieldErrors));
    } catch (e) {
      if (kDebugMode) {
        emit(DeleteAccountError('Terjadi kesalahan: ${e.toString()}'));
      } else {
        emit(
          DeleteAccountError(
            'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
    }
  }
}
