import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final _log = Logger('AuthRepository');

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> register(String name, String email, String password) async {
    _log.info('Registering: $email');
    try {
      await remoteDataSource.register(name, email, password);
      _log.info('Register successful');
    } on DioException catch (e) {
      ErrorHandler.handleRemoteException(e, _log, 'Register');
    } catch (e) {
      _log.severe('Unexpected register error', e);
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> login(String email, String password) async {
    _log.info('Logging in: $email');
    try {
      await remoteDataSource.login(email, password);
      _log.info('Login successful');
    } on DioException catch (e) {
      ErrorHandler.handleRemoteException(e, _log, 'Login');
    } catch (e) {
      _log.severe('Unexpected login error', e);
      throw UnexpectedException(e.toString());
    }
  }
}
