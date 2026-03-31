import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;
  final _log = Logger('AuthRemoteDataSource');

  AuthRemoteDataSource(this.dio);

  bool _parseRequiresOnboarding(dynamic value, {required bool defaultValue}) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }

    if (value is num) {
      return value == 1;
    }

    return defaultValue;
  }

  Future<(UserModel, String, bool)> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    if (AppEnv.useMockApi) {
      _log.info('USE_MOCK_API enabled, returning dummy register response');
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now().toUtc();
      final dummyUser = UserModel(
        id: 1,
        name: name,
        email: email,
        emailVerifiedAt: null,
        goal: null,
        cycleType: null,
        cycleStart: null,
        balance: null,
        profileUrl: null,
        createdAt: now,
        updatedAt: now,
      );

      return (dummyUser, 'dev-register-token', true);
    }

    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      final token = data['token'] as String;
      final requiresOnboarding = _parseRequiresOnboarding(
        data['requires_onboarding'],
        defaultValue: true,
      );

      return (user, token, requiresOnboarding);
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, 'Register');
    } catch (e) {
      _log.severe('Unexpected register error', e);
      throw UnexpectedException('Terjadi kesalahan sistem saat registrasi');
    }
  }

  Future<(UserModel, String, bool)> login(String email, String password) async {
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

      return (dummyUser, 'dev-token', false);
    }

    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      final token = data['token'] as String;
      final requiresOnboarding = _parseRequiresOnboarding(
        data['requires_onboarding'],
        defaultValue: false,
      );

      return (user, token, requiresOnboarding);
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, 'Login');
    } catch (e) {
      _log.severe('Unexpected login error', e);
      throw UnexpectedException('Terjadi kesalahan sistem saat login');
    }
  }

  Future<void> logout() async {
    if (AppEnv.useMockApi) {
      _log.info('USE_MOCK_API enabled, simulating logout response');
      await Future.delayed(const Duration(seconds: 1));

      return;
    }

    try {
      await dio.delete('/auth/logout');
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, 'Logout');
    } catch (e) {
      _log.severe('Unexpected logout error', e);
      throw UnexpectedException('Terjadi kesalahan sistem saat logout');
    }
  }

  Future<String> sendPasswordResetEmail(String email) async {
    if (AppEnv.useMockApi) {
      _log.info(
        'USE_MOCK_API enabled, simulating send password reset email response',
      );
      await Future.delayed(const Duration(seconds: 1));

      return 'Link reset password berhasil dikirim ke email Anda.';
    }

    try {
      final response = await dio.post(
        '/auth/password/email',
        data: {'email': email},
      );

      final responseData = response.data as Map<String, dynamic>?;
      final message = responseData?['message'] as String?;

      return message ?? 'Silakan cek email Anda untuk langkah berikutnya.';
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(
        e,
        _log,
        'Send Password Reset Email',
      );
    } catch (e) {
      _log.severe('Unexpected send password reset email error', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat mengirim email verifikasi',
      );
    }
  }

  Future<String> requestEmailVerification() async {
    if (AppEnv.useMockApi) {
      _log.info(
        'USE_MOCK_API enabled, simulating verify email request response',
      );
      await Future.delayed(const Duration(seconds: 1));

      return 'Email verifikasi berhasil dikirim.';
    }

    try {
      final response = await dio.get('/auth/verify-email/request');
      final responseData = response.data as Map<String, dynamic>?;
      final message = responseData?['message'] as String?;

      return message ?? 'Silakan cek email Anda untuk melakukan verifikasi.';
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(
        e,
        _log,
        'Request Email Verification',
      );
    } catch (e) {
      _log.severe('Unexpected request email verification error', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat mengirim email verifikasi',
      );
    }
  }
}
