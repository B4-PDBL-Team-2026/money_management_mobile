import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

import 'session_state.dart';

@LazySingleton()
class SessionCubit extends Cubit<SessionState> {
  final AuthRepository _authRepository;
  final EventBus _eventBus;
  late final StreamSubscription<dynamic> _sessionExpiredSubscription;
  final _log = Logger('SessionCubit');

  SessionCubit(this._authRepository, this._eventBus)
    : super(SessionUnauthenticated()) {
    _sessionExpiredSubscription = _eventBus.on<SessionExpiredEvent>().listen(
      (_) {
        // Only trigger logout if currently authenticated to prevent infinite loops
        if (state is SessionAuthenticated) {
          unawaited(logout());
        }
      },
    );
  }

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

  @override
  Future<void> close() async {
    await _sessionExpiredSubscription.cancel();
    return super.close();
  }
}