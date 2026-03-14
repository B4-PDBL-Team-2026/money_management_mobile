import 'package:dio/dio.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/features/auth/data/data_sources/local/auth_local_data_source.dart';

Dio createDioClient(AuthLocalDataSource authLocalDataSource) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppEnv.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = authLocalDataSource.getToken();

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
    ),
  );

  return dio;
}
