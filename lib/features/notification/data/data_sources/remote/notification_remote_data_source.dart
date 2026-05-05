import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/core/data/models/paginated_model.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/notification/data/models/notification_model.dart';
import 'package:money_management_mobile/features/notification/data/models/notification_registration_model.dart';
import 'package:money_management_mobile/features/notification/domain/entities/notification_entity.dart';

@LazySingleton()
class NotificationRemoteDataSource {
  final _log = Logger('NotificationRemoteDataSource');
  final Dio _dio;

  NotificationRemoteDataSource(this._dio);

  final List<NotificationModel> _notifications = <NotificationModel>[
    NotificationModel(
      id: 'today-budget-alert',
      createdAt: DateTime(2026, 4, 28),
      title: 'Anggaran Hampir Habis!',
      message:
          'Sisa anggaran harian kamu tinggal Rp 5000. Kurangi pengeluaran hari ini ya!',
      isRead: false,
      notificationCode: NotificationCode.fixedCostDue,
    ),
    NotificationModel(
      id: 'yesterday-budget-limit',
      createdAt: DateTime(2026, 4, 28),
      title: 'Batas Anggaran Terlampaui',
      message:
          'Kamu sudah melewati anggaran harian! Total pengeluaranmu hari ini Rp 9000 dari batas Rp 5000',
      isRead: false,
      notificationCode: NotificationCode.fixedCostDue,
    ),
    NotificationModel(
      id: 'yesterday-record-expense',
      createdAt: DateTime(2026, 4, 27),
      title: 'Jangan Lupa Catat Pengeluaran',
      message:
          'Kamu belum mencatat transaksi hari ini. Yuk mulai catat biar keuanganmu terkontrol',
      isRead: false,
      notificationCode: NotificationCode.transactionRecordingReminder,
    ),
    NotificationModel(
      id: 'budget-tip',
      createdAt: DateTime(2026, 4, 27),
      title: 'Tips Hemat Minggu Ini',
      message:
          'Coba batasi pengeluaran makan di luar maksimal 3x seminggu. Masak sendiri lebih hemat!',
      isRead: true,
      notificationCode: NotificationCode.transactionRecordingReminder,
    ),
    NotificationModel(
      id: 'netflix-due',
      createdAt: DateTime(2026, 4, 26),
      title: 'Jatuh Tempo - Netflix',
      message:
          'Netflix Rp 40.000 jatuh tempo hari ini. Pilih tindakan sekarang.',
      isRead: true,
      notificationCode: NotificationCode.fixedCostDue,
    ),
    NotificationModel(
      id: 'february-recap',
      createdAt: DateTime(2026, 4, 26),
      title: 'Rekap Bulan Februari',
      message:
          'Selamat! Bulan Februari kamu berhasil menghemat Rp 860.000 dari target. Pertahankan di Maret!',
      isRead: true,
      notificationCode: NotificationCode.transactionRecordingReminder,
    ),
    NotificationModel(
      id: 'motor-due',
      createdAt: DateTime(2026, 4, 26),
      title: 'Jatuh Tempo - Cicilan Motor',
      message:
          'Cicilan motor Rp 245.000 jatuh tempo hari ini. Pilih tindakan sekarang.',
      isRead: true,
      notificationCode: NotificationCode.fixedCostDue,
    ),
    NotificationModel(
      id: 'february-spending',
      createdAt: DateTime(2026, 4, 25),
      title: 'Jangan Lupa Catat Pengeluaran',
      message:
          'Kamu belum mencatat transaksi hari ini. Yuk mulai catat biar keuanganmu terkontrol',
      isRead: true,
      notificationCode: NotificationCode.transactionRecordingReminder,
    ),
  ];

  Future<PaginatedModel<NotificationModel>> getNotifications({
    int? page,
    int? perPage,
  }) async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(milliseconds: 400));

      final sortedNotifications = _notifications.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final safePage = page != null && page > 0 ? page : 1;
      final safePerPage = perPage != null && perPage > 0 ? perPage : 10;
      final startIndex = (safePage - 1) * safePerPage;
      var endIndex = startIndex + safePerPage;

      if (endIndex > sortedNotifications.length) {
        endIndex = sortedNotifications.length;
      }

      final pagedItems = startIndex >= sortedNotifications.length
          ? const <NotificationModel>[]
          : sortedNotifications.sublist(startIndex, endIndex);

      return PaginatedModel(
        items: pagedItems,
        currentPage: safePage,
        totalPages: (sortedNotifications.length / safePerPage).ceil(),
        totalItems: sortedNotifications.length,
      );
    }

    try {
      final response = await _dio.get(
        '/notifications',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      return PaginatedModel.fromJson(
        response.data as Map<String, dynamic>,
        NotificationModel.fromJson,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(
        e,
        _log,
        'Get Notifications',
      );
    } catch (e) {
      _log.severe('Unexpected error while fetching notifications', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat mengambil notifikasi',
      );
    }
  }

  Future<void> dismissNotification(String notificationId) async {
    _notifications.removeWhere((item) => item.id == notificationId);
  }

  Future<void> markAsRead(String notificationId) async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(milliseconds: 200));

      final targetIndex = _notifications.indexWhere(
        (item) => item.id == notificationId,
      );

      if (targetIndex < 0) {
        _log.warning('Notification not found for markAsRead: $notificationId');
        return;
      }

      _notifications[targetIndex] = _notifications[targetIndex].copyWith(
        isRead: true,
      );
      return;
    }

    try {
      await _dio.post('/notifications/$notificationId/read');
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(
        e,
        _log,
        'Mark Notification Read',
      );
    } catch (e) {
      _log.severe('Unexpected error while marking notification as read', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat menandai notifikasi terbaca',
      );
    }

    final targetIndex = _notifications.indexWhere(
      (item) => item.id == notificationId,
    );

    if (targetIndex < 0) {
      _log.warning('Notification not found for markAsRead: $notificationId');
      return;
    }

    _notifications[targetIndex] = _notifications[targetIndex].copyWith(
      isRead: true,
    );
  }

  Future<List<NotificationRegistrationModel>> getRegisteredDevices() async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(milliseconds: 200));
      return <NotificationRegistrationModel>[];
    }

    try {
      final response = await _dio.get('/notifications/device');
      final responseData = response.data as Map<String, dynamic>?;
      final data = responseData?['data'];
      final items = data is List ? data : const <dynamic>[];

      return items
          .whereType<Map<String, dynamic>>()
          .map(NotificationRegistrationModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(
        e,
        _log,
        'Get Registered Notification Devices',
      );
    } catch (e) {
      _log.severe('Unexpected error while fetching notification devices', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat mengambil data perangkat notifikasi',
      );
    }
  }

  Future<void> registerNotificationToken(
    NotificationRegistrationModel registrationData,
  ) async {
    try {
      await _dio.post('/notifications/device', data: registrationData.toJson());

      _log.info('Device notification token registered successfully');
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(
        e,
        _log,
        'RegisterNotificationToken',
      );
    } catch (e) {
      _log.severe('Unexpected error while registering notification token', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat mendaftar token notifikasi',
      );
    }
  }
}
