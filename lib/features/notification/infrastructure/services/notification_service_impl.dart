import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:money_management_mobile/features/notification/domain/services/notification_service.dart';

@LazySingleton(as: NotificationService)
class NotificationServiceImpl implements NotificationService {
  static const AndroidNotificationChannel _highImportanceChannel =
      AndroidNotificationChannel(
        'high_importance_channel', // Unique channel ID
        'High Importance Notifications', // User-visible channel name
        description: 'Channel for important finance updates.',
        importance: Importance.high,
      );

  final _log = Logger('NotificationServiceImpl');

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<NotificationPayload> _foregroundMessageController =
      StreamController<NotificationPayload>.broadcast();
  final StreamController<NotificationPayload> _openedMessageController =
      StreamController<NotificationPayload>.broadcast();
  final StreamController<String> _tokenRefreshController =
      StreamController<String>.broadcast();

  StreamSubscription<RemoteMessage>? _onForegroundMessageSubscription;
  StreamSubscription<RemoteMessage>? _onOpenedMessageSubscription;
  StreamSubscription<String>? _onTokenRefreshSubscription;

  bool _isInitialized = false;
  NotificationBootstrapResult? _bootstrapResult;

  @override
  Stream<NotificationPayload> get foregroundMessages =>
      _foregroundMessageController.stream;

  @override
  Stream<NotificationPayload> get openedMessages =>
      _openedMessageController.stream;

  @override
  Stream<String> get tokenRefreshes => _tokenRefreshController.stream;

  @override
  Future<NotificationBootstrapResult> initialize() async {
    if (_isInitialized) {
      return _bootstrapResult!;
    }

    try {
      final isPermissionGranted = await _requestNotificationPermission();

      await _fcm.setAutoInitEnabled(true);
      await _initializeLocalNotifications();
      await _ensureNotificationChannelIsCreated();
      final token = await _initializeFcmToken();
      await _initializeMessageListeners();

      final initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        _emitPayloadIfValid(initialMessage, _openedMessageController);
      }

      _isInitialized = true;
      _bootstrapResult = NotificationBootstrapResult(
        token: token,
        isPermissionGranted: isPermissionGranted,
      );

      return _bootstrapResult!;
    } catch (error, stackTrace) {
      _log.severe(
        'Failed to initialize notification service.',
        error,
        stackTrace,
      );

      rethrow;
    }
  }

  Future<bool> _requestNotificationPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _requestAndroidNotificationPermission();
    }

    final permissionSettings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );

    return permissionSettings.authorizationStatus ==
            AuthorizationStatus.authorized ||
        permissionSettings.authorizationStatus ==
            AuthorizationStatus.provisional;
  }

  Future<bool> _requestAndroidNotificationPermission() async {
    final androidLocalNotifications = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidLocalNotifications == null) {
      return false;
    }

    return await androidLocalNotifications.requestNotificationsPermission() ??
        false;
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    await _localNotificationsPlugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
  }

  Future<void> _ensureNotificationChannelIsCreated() async {
    final androidLocalNotifications = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidLocalNotifications == null) {
      return;
    }

    await androidLocalNotifications.createNotificationChannel(
      _highImportanceChannel,
    );
  }

  Future<String?> _initializeFcmToken() async {
    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final token = await _fcm.getToken();

        if (token != null && token.isNotEmpty) {
          _tokenRefreshController.add(token);

          return token;
        }
      } catch (e) {
        retryCount++;
        _log.warning('Attempt $retryCount failed to get FCM token: $e');

        if (retryCount >= maxRetries) rethrow;

        await Future.delayed(Duration(seconds: retryCount * 2));
      }
    }

    _onTokenRefreshSubscription ??= _fcm.onTokenRefresh.listen((newToken) {
      _tokenRefreshController.add(newToken);
    });

    return null;
  }

  Future<void> _initializeMessageListeners() async {
    _onForegroundMessageSubscription ??= FirebaseMessaging.onMessage.listen((
      message,
    ) {
      _showForegroundNotification(message);
      _emitPayloadIfValid(message, _foregroundMessageController);
    });

    _onOpenedMessageSubscription ??= FirebaseMessaging.onMessageOpenedApp
        .listen((message) {
          _emitPayloadIfValid(message, _openedMessageController);
        });
  }

  void _emitPayloadIfValid(
    RemoteMessage message,
    StreamController<NotificationPayload> controller,
  ) {
    try {
      final payload = _toNotificationPayload(message);
      if (payload == null) {
        return;
      }

      if (controller.isClosed) {
        _log.warning('Cannot add payload: controller is closed');
        return;
      }

      controller.add(payload);
    } catch (e, stackTrace) {
      _log.severe('Error emitting payload', e, stackTrace);
    }
  }

  NotificationPayload? _toNotificationPayload(RemoteMessage message) {
    final data = message.data;
    
    // Try to extract payload from nested JSON string first
    String? rawCode;
    String? rawTargetId;
    
    try {
      final payloadStr = data['payload'];
      if (payloadStr != null && payloadStr.isNotEmpty) {
        final parsedPayload = jsonDecode(payloadStr) as Map<String, dynamic>;
        rawCode = parsedPayload['notificationCode'] as String?;
        rawTargetId = parsedPayload['targetId'] as String? ?? parsedPayload['occurrenceId'] as String?;
      }
    } catch (e) {
      _log.warning('Failed to parse payload JSON: $e');
    }
    
    // Fallback to top-level fields
    rawCode ??= data['notificationCode'] as String? ?? data['notification_code'] as String?;
    rawTargetId ??= data['targetId'] as String? ?? data['target_id'] as String?;
    
    final notificationCode = NotificationCode.fromValue(rawCode);
    if (notificationCode == null) {
      _log.warning('Skipping notification: unknown code "$rawCode"');
      return null;
    }

    return NotificationPayload(
      code: notificationCode,
      targetId: rawTargetId,
    );
  }

  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = notification?.android;

    if (notification == null || android == null) {
      return;
    }

    _localNotificationsPlugin.show(
      id: message.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _highImportanceChannel.id, // Use channel ID yg sudah terdaftar
          _highImportanceChannel.name, // Channel name
          channelDescription: _highImportanceChannel.description,
          icon: android.smallIcon, // Custom icon dari message
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  @disposeMethod
  void dispose() {
    _onForegroundMessageSubscription?.cancel();
    _onForegroundMessageSubscription = null;

    _onOpenedMessageSubscription?.cancel();
    _onOpenedMessageSubscription = null;

    _onTokenRefreshSubscription?.cancel();
    _onTokenRefreshSubscription = null;

    _foregroundMessageController.close();
    _openedMessageController.close();
    _tokenRefreshController.close();
  }
}
