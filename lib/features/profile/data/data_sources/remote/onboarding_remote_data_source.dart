import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/features/profile/data/models/onboarding_payload_model.dart';

class OnboardingRemoteDataSource {
  final Dio dio;
  final _log = Logger('OnboardingRemoteDataSource');

  OnboardingRemoteDataSource(this.dio);

  Future<void> submitOnboarding(OnboardingPayloadModel payload) async {
    _log.info('Submitting onboarding payload');
    _log.fine('Onboarding payload: ${payload.toJson()}');

    if (AppEnv.useMockApi) {
      _log.info('USE_MOCK_API enabled, returning dummy onboarding response');
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    final response = await dio.post('/onboarding', data: payload.toJson());

    _log.fine('Onboarding response status: ${response.statusCode}');
    _log.fine('Onboarding response data: ${response.data}');

    if (response.statusCode != 200) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: 'Unexpected onboarding status code: ${response.statusCode}',
      );
    }

    final responseBody = response.data;
    if (responseBody is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: 'Invalid onboarding response format',
      );
    }

    if (responseBody['success'] != true) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: 'Onboarding response marked as unsuccessful',
      );
    }
  }
}
