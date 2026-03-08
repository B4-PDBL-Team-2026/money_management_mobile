import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSource(this.dio);

  Future<void> register(String name, String email, String password) async {
    // TODO: Implement API call to register user
    await Future.delayed(const Duration(seconds: 2));
  }
}
