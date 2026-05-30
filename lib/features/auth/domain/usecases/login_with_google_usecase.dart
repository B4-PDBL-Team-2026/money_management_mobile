import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

@Injectable()
class LoginWithGoogleUseCase {
  final AuthRepository repository;

  LoginWithGoogleUseCase(this.repository);

  Future<(UserEntity, String, bool)> execute(String googleToken) async {
    final (user, token, requiresOnboarding) =
        await repository.loginWithGoogle(googleToken);
    await repository.saveSession(
      user,
      token,
      requiresOnboarding: requiresOnboarding,
    );
    return (user, token, requiresOnboarding);
  }
}
