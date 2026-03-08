import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSource(this.dio);

  Future<void> register(String name, String email, String password) async {
    // TODO: Implement API call to register user
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> login(String email, String password) async {
    // TODO: Implement API call to login user
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate authentication
    if (email != "user@mail.com" || password != "1234567890") {
      throw Exception("Email atau password salah");
    }
  }
}
