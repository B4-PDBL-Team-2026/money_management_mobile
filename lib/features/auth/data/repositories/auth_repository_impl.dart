import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:money_management_mobile/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final _log = Logger('AuthRepository');

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<(UserEntity, String, bool)> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    _log.info('Registering: $email');
    try {
      final (user, token, requiresOnboarding) = await remoteDataSource.register(
        name,
        email,
        password,
        passwordConfirmation,
      );
      _log.info('Register successful');
      return (user, token, requiresOnboarding);
    } on DioException catch (e) {
      ErrorHandler.handleRemoteException(e, _log, 'Register');
      rethrow;
    } catch (e) {
      _log.severe('Unexpected register error', e);
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<(UserEntity, String, bool)> login(
    String email,
    String password,
  ) async {
    _log.info('Logging in: $email');
    try {
      final (user, token, requiresOnboarding) = await remoteDataSource.login(
        email,
        password,
      );
      _log.info('Login successful for user: ${user.email}');
      return (user, token, requiresOnboarding);
    } on DioException catch (e) {
      ErrorHandler.handleRemoteException(e, _log, 'Login');
      rethrow;
    } catch (e) {
      _log.severe('Unexpected login error', e);
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> saveSession(
    UserEntity user,
    String token, {
    required bool requiresOnboarding,
  }) {
    return localDataSource.saveSession(
      user,
      token,
      requiresOnboarding: requiresOnboarding,
    );
  }

  @override
  (UserEntity, String, bool)? getSavedSession() => localDataSource.getSession();

  @override
  String? getToken() => localDataSource.getToken();

  @override
  Future<void> clearSession() => localDataSource.clearSession();
}
