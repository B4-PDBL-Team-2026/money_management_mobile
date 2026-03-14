import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;
  final _log = Logger('AuthRemoteDataSource');

  AuthRemoteDataSource(this.dio);

  Future<void> register(String name, String email, String password) async {
    _log.fine('Sending register request for email: $email');
    _log.fine('Request payload: {name: $name, email: $email, password: ***}');

    // TODO: Implement API call to register user
    await Future.delayed(const Duration(seconds: 2));

    _log.fine('Register response received successfully');
  }

  Future<(UserModel, String)> login(String email, String password) async {
    _log.fine('Sending login request for email: $email');
    _log.fine('Request payload: {email: $email, password: ***}');

    if (AppEnv.useMockApi) {
      _log.info('USE_MOCK_API enabled, returning dummy login response');
      await Future.delayed(const Duration(seconds: 1));

      final dummyUser = UserModel(
        id: 1,
        name: 'Development User',
        email: email,
        emailVerifiedAt: DateTime.now().toUtc(),
        goal: 'Development Goal',
        cycleType: 'monthly',
        cycleStart: DateTime.now().toUtc(),
        balance: 1250.5,
        profileUrl: null,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      return (dummyUser, 'dev-token');
    }

    final response = await dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    _log.fine('Login response received: ${response.statusCode}');
    _log.fine('Login response data: ${response.data}');

    final data = response.data['data'] as Map<String, dynamic>;
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    final token = data['token'] as String;

    return (user, token);
  }
}
