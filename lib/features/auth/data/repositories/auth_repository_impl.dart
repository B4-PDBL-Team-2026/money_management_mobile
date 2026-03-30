import 'package:money_management_mobile/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:money_management_mobile/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<(UserEntity, String, bool)> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final (user, token, requiresOnboarding) = await remoteDataSource.register(
      name,
      email,
      password,
      passwordConfirmation,
    );

    return (user, token, requiresOnboarding);
  }

  @override
  Future<(UserEntity, String, bool)> login(
    String email,
    String password,
  ) async {
    final (user, token, requiresOnboarding) = await remoteDataSource.login(
      email,
      password,
    );

    return (user, token, requiresOnboarding);
  }

  @override
  Future<void> saveSession(
    UserEntity user,
    String token, {
    required bool requiresOnboarding,
  }) {
    return Future.wait([
      localDataSource.storeUser(user),
      localDataSource.storeToken(token),
      localDataSource.storeRequiresOnboarding(requiresOnboarding),
    ]);
  }

  @override
  (UserEntity, String, bool)? getSavedSession() =>
      localDataSource.getToken() != null
      ? (
          localDataSource.getUser()!,
          localDataSource.getToken()!,
          localDataSource.getRequiresOnboarding() ?? false,
        )
      : null;

  @override
  String? getToken() => localDataSource.getToken();

  @override
  Future<void> updateRequiresOnboarding(bool requiresOnboarding) {
    return localDataSource.storeRequiresOnboarding(requiresOnboarding);
  }

  @override
  Future<String> sendPasswordResetEmail(String email) {
    return remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> clearSession() async {
    try {
      await remoteDataSource.logout();
    } catch (e) {
      await localDataSource.clearAll();

      rethrow;
    }
  }
}
