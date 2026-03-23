import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';

class ErrorHandler {
  static String _extractMessage(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) {
      return 'Terjadi kesalahan';
    }

    final baseMessage = responseData['message']?.toString() ?? 'Terjadi kesalahan';
    final errors = responseData['errors'];

    if (errors is! Map) {
      return baseMessage;
    }

    final details = <String>[];

    for (final entry in errors.entries) {
      final value = entry.value;

      if (value is List) {
        for (final item in value) {
          final text = item.toString().trim();
          if (text.isNotEmpty) {
            details.add(text);
          }
        }
        continue;
      }

      final text = value.toString().trim();
      if (text.isNotEmpty) {
        details.add(text);
      }
    }

    if (details.isEmpty) {
      return baseMessage;
    }

    return '$baseMessage ${details.join(' ')}'.trim();
  }

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
      final message = _extractMessage(e.response?.data);

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
