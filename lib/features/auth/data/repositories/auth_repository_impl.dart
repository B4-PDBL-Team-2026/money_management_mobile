import 'package:money_management_mobile/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> register(String name, String email, String password) async {
    try {
      await remoteDataSource.register(name, email, password);
    } catch (e) {
      throw Exception("Gagal mendaftar: ${e.toString()}");
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      await remoteDataSource.login(email, password);
    } catch (e) {
      throw Exception("Gagal login: ${e.toString()}");
    }
  }
}
