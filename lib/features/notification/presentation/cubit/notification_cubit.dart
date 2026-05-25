import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_messages.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/features/notification/domain/services/notification_service.dart';
import 'package:money_management_mobile/features/notification/domain/usecases/notification_init_usecase.dart';
import 'package:money_management_mobile/features/notification/domain/usecases/notification_unregister_usecase.dart';
import 'package:money_management_mobile/features/notification/presentation/cubit/notification_state.dart';

@LazySingleton()
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationInitUsecase _notificationInitUsecase;
  final NotificationUnregisterUsecase _notificationUnregisterUsecase;
  final NotificationService _notificationService;
  final EventBus _eventBus;
  late final StreamSubscription<dynamic> _initSubscription;

  final _log = Logger('NotificationCubit');

  StreamSubscription<NotificationPayload>? _foregroundMessageSubscription;
  StreamSubscription<NotificationPayload>? _openedMessageSubscription;

  NotificationCubit(
    this._notificationInitUsecase,
    this._notificationUnregisterUsecase,
    this._notificationService,
    this._eventBus,
  ) : super(NotificationInitial()) {
    _initSubscription = _eventBus.on<NotificationInitializeEvent>().listen(
      (_) => initialize(),
    );
  }

  Future<void> initialize() async {
    if (super.state is NotificationReady ||
        super.state is NotificationInitializing) {
      _log.info('Notification already initialized or initializing, skipping.');
      return;
    }

    emit(NotificationInitializing());

    try {
      await _foregroundMessageSubscription?.cancel();
      await _openedMessageSubscription?.cancel();

      _foregroundMessageSubscription = _notificationService.foregroundMessages
          .listen(
            _handleForegroundMessage,
            onError: (error, stackTrace) {
              _log.severe(
                'Error in foreground message stream',
                error,
                stackTrace,
              );
            },
          );

      _openedMessageSubscription = _notificationService.openedMessages.listen(
        _handleOpenedMessage,
        onError: (error, stackTrace) {
          _log.severe('Error in opened message stream', error, stackTrace);
        },
      );

      await _notificationInitUsecase.execute();

      emit(NotificationReady());
    } catch (error, stackTrace) {
      _log.severe(
        'Failed to initialize notification cubit.',
        error,
        stackTrace,
      );
      emit(
        NotificationError(
          AppMessages.unknownError,
        ),
      );
    }
  }

  Future<void> unregisterCurrentDevice() async {
    try {
      await _notificationUnregisterUsecase.execute();
    } catch (error, stackTrace) {
      _log.warning(
        'Failed to unregister current device from notifications.',
        error,
        stackTrace,
      );
      rethrow;
    }
  }

  void _handleForegroundMessage(NotificationPayload message) {
    try {
      _eventBus.fire(const NotificationCenterChangesEvent());
    } catch (e, stackTrace) {
      _log.severe(
        'Failed to fire NotificationCenterChangesEvent',
        e,
        stackTrace,
      );
    }
  }

  void _handleOpenedMessage(NotificationPayload message) {
    _eventBus.fire(const NotificationCenterChangesEvent());

    final routePath = message.code.routePath;

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

  @override
  Future<void> close() {
    _foregroundMessageSubscription?.cancel();
    _openedMessageSubscription?.cancel();
    _initSubscription.cancel();
    return super.close();
  }
}
