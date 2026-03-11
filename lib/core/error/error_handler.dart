import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';

class ErrorHandler {
  static void handleRemoteException(
    DioException e,
    Logger log,
    String context,
  ) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      log.warning('$context failed: Connection timeout', e);
      throw NetworkException("Koneksi timeout, periksa internet Anda");
    }

    if (e.type == DioExceptionType.connectionError) {
      log.warning('$context failed: Connection error', e);
      throw NetworkException("Tidak dapat terhubung ke server");
    }

    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final message = e.response?.data['message'] ?? 'Terjadi kesalahan';

      if (statusCode != null && statusCode >= 500) {
        log.severe('$context failed: Server error ($statusCode): $message', e);
        throw ServerException("Error server: $message");
      }

      log.warning('$context failed: Client error ($statusCode): $message', e);
      throw ServerException(message);
    }

    log.warning('$context failed: Network issue', e);
    throw NetworkException("Koneksi internet bermasalah");
  }
}
