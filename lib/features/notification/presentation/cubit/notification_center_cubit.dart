import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:money_management_mobile/features/notification/domain/repositories/notification_center_repository.dart';
import 'package:money_management_mobile/features/notification/presentation/cubit/notification_center_state.dart';

@LazySingleton()
class NotificationCenterCubit extends Cubit<NotificationCenterState> {
  final NotificationCenterRepository _notificationCenterRepository;
  final EventBus _eventBus;
  late final StreamSubscription<dynamic> _refreshSubscription;

  final _log = Logger('NotificationCenterCubit');

  NotificationCenterCubit(this._notificationCenterRepository, this._eventBus)
    : super(NotificationCenterInitial()) {
    _refreshSubscription = _eventBus
        .on<NotificationCenterChangesEvent>()
        .listen((_) => fetchNotifications(forceRefresh: true));
  }

  Future<void> fetchNotifications({bool forceRefresh = false}) async {
    final currentState = state;

    if (!forceRefresh && currentState is NotificationCenterSuccess) {
      return;
    }

    final selectedFilter = currentState is NotificationCenterSuccess
        ? currentState.selectedFilter
        : NotificationCenterFilter.all;

    emit(NotificationCenterLoading());

    try {
      final notifications = await _notificationCenterRepository
          .getNotifications();

      emit(
        NotificationCenterSuccess(
          allNotifications: notifications,
          selectedFilter: selectedFilter,
        ),
      );
    } on NetworkException catch (e) {
      emit(NotificationCenterError(e.message));
    } on UnexpectedException catch (e) {
      emit(NotificationCenterError(e.message));
    } catch (e) {
      _log.severe('Unexpected error while fetching notifications', e);
      if (kDebugMode) {
        emit(NotificationCenterError('Terjadi kesalahan: ${e.toString()}'));
      } else {
        emit(
          NotificationCenterError(
            'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
    }
  }

  void changeFilter(NotificationCenterFilter filter) {
    final currentState = state;

    if (currentState is! NotificationCenterSuccess) {
      return;
    }

    emit(currentState.copyWith(selectedFilter: filter));
  }

  Future<void> markAsRead(String notificationId) async {
    final currentState = state;

    if (currentState is! NotificationCenterSuccess) {
      return;
    }

    final updatedNotifications = currentState.allNotifications.map((item) {
      if (item.id != notificationId) {
        return item;
      }

      return NotificationEntity(
        id: item.id,
        createdAt: item.createdAt,
        title: item.title,
        message: item.message,
        isRead: true,
        notificationCode: item.notificationCode,
      );
    }).toList();

    emit(currentState.copyWith(allNotifications: updatedNotifications));

    try {
      await _notificationCenterRepository.markAsRead(notificationId);
      _eventBus.fire(const NotificationCenterChangesEvent());
    } catch (error, stackTrace) {
      _log.warning(
        'Failed to mark notification as read, reloading list.',
        error,
        stackTrace,
      );
      await fetchNotifications(forceRefresh: true);
    }
  }

  Future<void> dismissNotification(String notificationId) async {
    final currentState = state;

    if (currentState is! NotificationCenterSuccess) {
      return;
    }

    final updatedNotifications = currentState.allNotifications
        .where((item) => item.id != notificationId)
        .toList();

    emit(currentState.copyWith(allNotifications: updatedNotifications));

    try {
      await _notificationCenterRepository.dismissNotification(notificationId);
      _eventBus.fire(const NotificationCenterChangesEvent());
    } catch (error, stackTrace) {
      _log.warning(
        'Failed to dismiss notification, reloading list.',
        error,
        stackTrace,
      );
      await fetchNotifications(forceRefresh: true);
    }
  }

  @override
  Future<void> close() {
    _refreshSubscription.cancel();
    return super.close();
  }
}
