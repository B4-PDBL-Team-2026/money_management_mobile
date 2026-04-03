import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

@Injectable()
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<(UserEntity, String, bool)> execute(
    String email,
    String password,
  ) async {
    final (user, token, requiresOnboarding) = await repository.login(
      email,
      password,
    );

    await repository.saveSession(
      user,
      token,
      requiresOnboarding: requiresOnboarding,
    );

    return (user, token, requiresOnboarding);
  }
}
