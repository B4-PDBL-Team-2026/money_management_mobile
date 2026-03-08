import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<void> execute(String email, String password) {
    return repository.login(email, password);
  }
}
