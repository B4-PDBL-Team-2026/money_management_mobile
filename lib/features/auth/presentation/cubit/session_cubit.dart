import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

import 'session_state.dart';

@LazySingleton()
class SessionCubit extends Cubit<SessionState> {
  final AuthRepository _authRepository;
  final _log = Logger('SessionCubit');

  SessionCubit(this._authRepository) : super(SessionUnauthenticated());

  Future<void> restoreSession() async {
    _log.info('Restoring local auth session');
    final session = _authRepository.getSavedSession();

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

  Future<void> markOnboardingAsDone() async {
    try {
      if (state is! SessionAuthenticated) {
        _log.warning('Attempted to complete onboarding while unauthenticated');
        throw Exception('User must be authenticated to complete onboarding');
      }

      await _authRepository.updateRequiresOnboarding(false);

      emit((state as SessionAuthenticated).copyWith(requiresOnboarding: false));
    } catch (e) {
      _log.severe('Error occurred while completing onboarding', e);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.clearSession();
    } catch (e) {
      _log.severe('Error occurred during logout', e);
    }

    emit(SessionUnauthenticated());
  }
}
