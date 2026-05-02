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
import 'package:money_management_mobile/features/notification/domain/usecases/notification_init_usecase.dart';
import 'package:money_management_mobile/features/notification/presentation/cubit/notification_state.dart';

@LazySingleton()
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationInitUsecase _notificationInitUsecase;
  final EventBus _eventBus;
  late final StreamSubscription<dynamic> _initSubscription;

  final _log = Logger('NotificationCubit');

  StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;
  StreamSubscription<RemoteMessage>? _openedMessageSubscription;

  NotificationCubit(this._notificationInitUsecase, this._eventBus)
    : super(NotificationInitial()) {
    _initSubscription = _eventBus.on<NotificationInitializeEvent>().listen(
      (_) => initialize(),
    );
  }

  Future<void> initialize() async {
    _log.info('Starting notification cubit initialization.');
    if (super.state is NotificationReady ||
        super.state is NotificationInitializing) {
      return;
    }

    emit(NotificationInitializing());

    try {
      // _foregroundMessageSubscription = _notificationService.foregroundMessages
      //     .listen(_handleForegroundMessage);
      // _openedMessageSubscription = _notificationService.openedMessages.listen(
      //   _handleOpenedMessage,
      // );

      // Subscribe before bootstrap so initial/opened FCM events are not missed.
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
    _initSubscription.cancel();
    return super.close();
  }
}
