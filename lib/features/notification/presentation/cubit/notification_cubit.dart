import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/features/notification/data/services/notification_service.dart';
import 'package:money_management_mobile/features/notification/presentation/cubit/notification_state.dart';

@LazySingleton()
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService _notificationService;
  final EventBus _eventBus;
  final _log = Logger('NotificationCubit');

  StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;
  StreamSubscription<RemoteMessage>? _openedMessageSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;
  bool _isInitialized = false;

  NotificationCubit(this._notificationService, this._eventBus)
    : super(NotificationInitial());

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    emit(NotificationInitializing());

    try {
      final bootstrapResult = await _notificationService.initialize();

      _foregroundMessageSubscription = _notificationService.foregroundMessages
          .listen(_handleForegroundMessage);
      _openedMessageSubscription = _notificationService.openedMessages.listen(
        _handleOpenedMessage,
      );
      _tokenRefreshSubscription = _notificationService.tokenRefreshes.listen(
        _handleTokenRefresh,
      );

      _isInitialized = true;
      emit(
        NotificationReady(
          token: bootstrapResult.token,
          isPermissionGranted: bootstrapResult.isPermissionGranted,
        ),
      );
    } catch (error, stackTrace) {
      _log.severe(
        'Failed to initialize notification cubit.',
        error,
        stackTrace,
      );
      emit(
        NotificationError(
          'Gagal menginisialisasi notifikasi. Silakan coba lagi.',
        ),
      );
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    _dispatchRefreshEvents(message.data);
  }

  void _handleOpenedMessage(RemoteMessage message) {
    _dispatchRefreshEvents(message.data);

    final route = _readRoute(message.data);
    if (route == null) {
      return;
    }

    try {
      AppRouter.router.push(route);

      final currentState = state;
      if (currentState is NotificationReady) {
        emit(currentState.copyWith(lastOpenedRoute: route));
      }
    } catch (error, stackTrace) {
      _log.warning(
        'Failed to navigate from notification payload.',
        error,
        stackTrace,
      );
    }
  }

  void _handleTokenRefresh(String token) {
    final currentState = state;
    if (currentState is NotificationReady) {
      emit(currentState.copyWith(token: token));
    }
  }

  void _dispatchRefreshEvents(Map<String, dynamic> payload) {
    final refreshValue = payload['refresh'] ?? payload['sync'];
    final refreshTargets = _extractRefreshTargets(refreshValue);

    for (final refreshTarget in refreshTargets) {
      switch (refreshTarget) {
        case 'all':
          _fireAllRefreshEvents();
          break;
        case 'categories':
          _eventBus.fire(const RefreshCategoriesEvent());
          break;
        case 'transactions':
          _eventBus.fire(const TransactionChangesEvent());
          break;
        case 'fixed_cost_templates':
          _eventBus.fire(const FixedCostTemplateChangesEvent());
          break;
        case 'fixed_cost_occurrences':
          _eventBus.fire(const FixedCostOccurrencesChangesEvent());
          break;
      }
    }
  }

  Set<String> _extractRefreshTargets(dynamic refreshValue) {
    if (refreshValue is String) {
      return refreshValue
          .split(',')
          .map((value) => value.trim().toLowerCase())
          .where((value) => value.isNotEmpty)
          .toSet();
    }

    if (refreshValue is List) {
      return refreshValue
          .whereType<String>()
          .map((value) => value.trim().toLowerCase())
          .where((value) => value.isNotEmpty)
          .toSet();
    }

    return <String>{};
  }

  String? _readRoute(Map<String, dynamic> payload) {
    final route = payload['route'];
    if (route is! String) {
      return null;
    }

    final normalizedRoute = route.trim();
    if (!normalizedRoute.startsWith('/')) {
      return null;
    }

    return normalizedRoute;
  }

  void _fireAllRefreshEvents() {
    _eventBus.fire(const RefreshCategoriesEvent());
    _eventBus.fire(const TransactionChangesEvent());
    _eventBus.fire(const FixedCostTemplateChangesEvent());
    _eventBus.fire(const FixedCostOccurrencesChangesEvent());
  }

  @override
  Future<void> close() {
    _foregroundMessageSubscription?.cancel();
    _openedMessageSubscription?.cancel();
    _tokenRefreshSubscription?.cancel();
    return super.close();
  }
}
