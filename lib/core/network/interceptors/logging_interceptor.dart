import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class LoggingInterceptor extends Interceptor {
  final _log = Logger('HTTP');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log.info('--> ${options.method.toUpperCase()} ${options.uri}');
    _log.fine('Headers: ${options.headers}');
    _log.fine('Body: ${options.data}');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log.info('<-- ${response.statusCode} ${response.requestOptions.uri}');
    _log.fine('Response: ${response.data}');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode != 401) {
      _log.severe(
        '<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}',
      );
      _log.severe('Message: ${err.message}');
      _log.severe('Error Data: ${err.response?.data}');
    }

    super.onError(err, handler);
  }
}
