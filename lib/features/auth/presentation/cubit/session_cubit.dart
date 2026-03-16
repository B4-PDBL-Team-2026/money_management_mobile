import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/restore_session_usecase.dart';

import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final RestoreSessionUseCase restoreSessionUseCase;
  final LogoutUseCase logoutUseCase;
  final _log = Logger('SessionCubit');

  SessionCubit(this.restoreSessionUseCase, this.logoutUseCase)
    : super(SessionUnauthenticated());

  Future<void> restoreSession() async {
    _log.info('Restoring local auth session');
    final session = restoreSessionUseCase.execute();

    if (session == null) {
      _log.info('No saved auth session found');
      emit(SessionUnauthenticated());
      return;
    }

    final (user, token, requiresOnboarding) = session;
    _log.info('Auth session restored for user: ${user.email}');
    emit(
      SessionAuthenticated(
        user: user,
        token: token,
        requiresOnboarding: requiresOnboarding,
      ),
    );
  }

  void authenticate({
    required UserEntity user,
    required String token,
    required bool requiresOnboarding,
  }) {
    _log.info('Session authenticated for user: ${user.email}');
    emit(
      SessionAuthenticated(
        user: user,
        token: token,
        requiresOnboarding: requiresOnboarding,
      ),
    );
  }

  Future<void> logout() async {
    _log.info('Logging out current session');
    await logoutUseCase.execute();
    emit(SessionUnauthenticated());
  }
}
