import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/register_usecase.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;

  AuthCubit(this.registerUseCase) : super(AuthInitial());

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());

    try {
      await registerUseCase.execute(name, email, password);

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
