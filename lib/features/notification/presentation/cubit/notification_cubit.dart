import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/features/notification/domain/entities/notification_entity.dart';
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

  NotificationCubit(this._notificationService, this._eventBus)
    : super(NotificationInitial());

  Future<void> initialize() async {
    if (super.state is NotificationReady ||
        super.state is NotificationInitializing) {
      return;
    }

    emit(NotificationInitializing());

    try {
      _foregroundMessageSubscription = _notificationService.foregroundMessages
          .listen(_handleForegroundMessage);
      _openedMessageSubscription = _notificationService.openedMessages.listen(
        _handleOpenedMessage,
      );
      _tokenRefreshSubscription = _notificationService.tokenRefreshes.listen(
        _handleTokenRefresh,
      );

      // Subscribe before bootstrap so initial/opened FCM events are not missed.
      final bootstrapResult = await _notificationService.initialize();

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
    _eventBus.fire(const NotificationCenterChangesEvent());
  }

  void _handleOpenedMessage(RemoteMessage message) {
    _log.info('Handling opened data: ${message.data}');
    _eventBus.fire(const NotificationCenterChangesEvent());

    final routePath = _resolveRoutePath(message.data);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (routePath == null) {
          return;
        }

        AppRouter.router.push(routePath);
      } catch (error, stackTrace) {
        _log.warning(
          'Failed to navigate from notification payload.',
          error,
          stackTrace,
        );
      }
    });
  }

  void _handleTokenRefresh(String token) {
    final currentState = state;

    if (currentState is NotificationReady) {
      emit(currentState.copyWith(token: token));
    }
  }

  String? _resolveRoutePath(Map<String, dynamic> data) {
    final rawCode =
        data['notificationCode'] as String? ??
        data['notification_code'] as String?;
    final notificationCode = NotificationCode.fromValue(rawCode);

    return notificationCode?.routePath;
  }

  @override
  Future<void> close() {
    _foregroundMessageSubscription?.cancel();
    _openedMessageSubscription?.cancel();
    _tokenRefreshSubscription?.cancel();
    return super.close();
  }
}
