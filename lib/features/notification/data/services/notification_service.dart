import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/features/notification/data/data_source/local/notification_local_data_source.dart';

class NotificationBootstrapResult {
  final String? token;
  final bool isPermissionGranted;

  NotificationBootstrapResult({
    required this.token,
    required this.isPermissionGranted,
  });
}

@LazySingleton()
class NotificationService {
  static const AndroidNotificationChannel _highImportanceChannel =
      AndroidNotificationChannel(
        'high_importance_channel', // Unique channel ID
        'High Importance Notifications', // User-visible channel name
        description: 'Channel for important finance updates.',
        importance: Importance.high,
      );

  final NotificationLocalDataSource _notificationLocalDataSource;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final _log = Logger('NotificationService');

  final StreamController<RemoteMessage> _foregroundMessageController =
      StreamController<RemoteMessage>.broadcast();

  final StreamController<RemoteMessage> _openedMessageController =
      StreamController<RemoteMessage>.broadcast();

  final StreamController<String> _tokenRefreshController =
      StreamController<String>.broadcast();

  StreamSubscription<RemoteMessage>? _onForegroundMessageSubscription;
  StreamSubscription<RemoteMessage>? _onOpenedMessageSubscription;
  StreamSubscription<String>? _onTokenRefreshSubscription;

  bool _isInitialized = false;

  NotificationService(this._notificationLocalDataSource);

  Stream<RemoteMessage> get foregroundMessages =>
      _foregroundMessageController.stream;
  Stream<RemoteMessage> get openedMessages => _openedMessageController.stream;
  Stream<String> get tokenRefreshes => _tokenRefreshController.stream;

  Future<NotificationBootstrapResult> initialize() async {
    if (_isInitialized) {
      return NotificationBootstrapResult(
        token: _notificationLocalDataSource.getFcmToken(),
        isPermissionGranted: true,
      );
    }

    try {
      final isPermissionGranted = await _requestNotificationPermission();

      await _fcm.setAutoInitEnabled(true);
      await _initializeLocalNotifications();
      await _ensureNotificationChannelIsCreated();
      await _initializeFcmToken();
      await _initializeMessageListeners();

      final initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        _openedMessageController.add(initialMessage);
      }

      _isInitialized = true;

      return NotificationBootstrapResult(
        token: _notificationLocalDataSource.getFcmToken(),
        isPermissionGranted: isPermissionGranted,
      );
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
    if (_isAndroid) {
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

  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

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

  Future<void> _initializeFcmToken() async {
    final token = await _fcm.getToken();

    if (token != null && token.isNotEmpty) {
      await _notificationLocalDataSource.saveFcmToken(token);
      _tokenRefreshController.add(token);
    }

    _onTokenRefreshSubscription ??= _fcm.onTokenRefresh.listen((
      newToken,
    ) async {
      await _notificationLocalDataSource.saveFcmToken(newToken);
      _tokenRefreshController.add(newToken);
    });
  }

  Future<void> _initializeMessageListeners() async {
    _onForegroundMessageSubscription ??= FirebaseMessaging.onMessage.listen((
      message,
    ) {
      _showForegroundNotification(message);
      _foregroundMessageController.add(message);
    });

    _onOpenedMessageSubscription ??= FirebaseMessaging.onMessageOpenedApp
        .listen((message) {
          _openedMessageController.add(message);
        });
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
}
