import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

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

  Future<void> login(String email, String password) async {
    _log.fine('Sending login request for email: $email');
    _log.fine('Request payload: {email: $email, password: ***}');
    
    // TODO: Implement API call to login user
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate authentication
    if (email != "user@mail.com" || password != "1234567890") {
      _log.fine('Login failed: Invalid credentials');
      throw Exception("Email atau password salah");
    }
    
    _log.fine('Login response received successfully');
  }
}
