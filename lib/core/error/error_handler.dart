import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';

class ErrorHandler {
  static String _extractMessage(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) {
      throw 'Terjadi kesalahan';
    }

    final baseMessage =
        responseData['message']?.toString() ?? 'Terjadi kesalahan';
    final errors = responseData['errors'];

    if (errors is! Map) {
      throw baseMessage;
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
      throw baseMessage;
    }

    throw '$baseMessage ${details.join(' ')}'.trim();
  }

  static Exception handleRemoteException(
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
        throw ServerException(
          "Terjadi masalah pada server. Silakan coba lagi nanti.",
        );
      }

      if (statusCode == 401) {
        log.warning('$context failed: Unauthorized (401)', e);
        throw UnauthorizedException(
          message.isNotEmpty
              ? message
              : "Sesi telah berakhir, silakan login kembali",
        );
      }

      if (statusCode == 400) {
        log.warning('$context failed: Validation error (400): $message', e);
        throw ValidationException(message);
      }

      // client Error lainnya (402 - 499)
      log.warning('$context failed: Client error ($statusCode): $message', e);
      throw ServerException(message);
    }

    // fallback untuk error Dio lainnya
    log.warning('$context failed: Unknown network issue', e);
    throw NetworkException("Koneksi internet bermasalah");
  }
}
