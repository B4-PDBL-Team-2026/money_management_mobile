import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<(UserEntity, String)> execute(String email, String password) async {
    final (user, token) = await repository.login(email, password);
    await repository.saveSession(user, token);
    return (user, token);
  }
}
