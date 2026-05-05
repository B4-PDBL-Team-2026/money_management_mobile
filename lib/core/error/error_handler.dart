import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';

class ErrorHandler {
  static String _extractMessage(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) {
      return 'Terjadi kesalahan'; // UBAH: dari return menjadi return
    }

    final baseMessage =
        responseData['message']?.toString() ?? 'Terjadi kesalahan';

    final errors = responseData['data'] ?? responseData['errors'];

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

  static Exception handleRemoteException(
    DioException e,
    Logger log,
    String context,
  ) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      log.warning('$context failed: Connection timeout', e);
      return NetworkException("Koneksi timeout, periksa internet Anda");
    }

    if (e.type == DioExceptionType.connectionError) {
      log.warning('$context failed: Connection error', e);
      return NetworkException("Tidak dapat terhubung ke server");
    }

    if (e.response != null) {
      final statusCode = e.response!.statusCode;

      final message = _extractMessage(e.response?.data);

      if (statusCode != null && statusCode >= 500) {
        log.severe('$context failed: Server error ($statusCode): $message', e);
        return ServerException(
          "Terjadi masalah pada server. Silakan coba lagi nanti.",
        );
      }

      if (statusCode == 401) {
        log.warning('$context failed: Unauthorized (401)', e);
        return UnauthorizedException(
          message.isNotEmpty
              ? message
              : "Sesi telah berakhir, silakan login kembali",
        );
      }

      if (statusCode == 422 || statusCode == 400) {
        log.warning(
          '$context failed: Validation error ($statusCode): $message',
          e,
        );

        Map<String, List<String>>? fieldErrors;
        final responseData = e.response?.data;

        if (responseData is Map<String, dynamic>) {
          final dynamic rawData = responseData['data'] ?? responseData['errors'];

          if (rawData is Map<String, dynamic>) {
            fieldErrors = rawData.map((String key, dynamic value) {
              if (value is List) {
                final List<String> stringList = value.map((dynamic item) => item.toString()).toList();
                return MapEntry(key, stringList);
              }

              return MapEntry(key, <String>[value.toString()]);
            });
          }
        }

        return BusinessRuleException(message, fieldErrors);
      }

      // client Error lainnya (402 - 499)
      log.warning('$context failed: Client error ($statusCode): $message', e);
      return ServerException(message);
    }

    // fallback untuk error Dio lainnya
    log.warning('$context failed: Unknown network issue', e);
    return NetworkException("Koneksi internet bermasalah");
  }
}
