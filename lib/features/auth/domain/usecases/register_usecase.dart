import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

@Injectable()
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<(UserEntity, String, bool)> execute(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final (user, token, requiresOnboarding) = await repository.register(
      name,
      email,
      password,
      passwordConfirmation,
    );
    await repository.saveSession(
      user,
      token,
      requiresOnboarding: requiresOnboarding,
    );
    return (user, token, requiresOnboarding);
  }
}
