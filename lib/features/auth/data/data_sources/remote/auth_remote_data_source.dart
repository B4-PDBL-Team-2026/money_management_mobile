import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
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
