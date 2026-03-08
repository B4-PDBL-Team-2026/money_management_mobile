import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> execute(String name, String email, String password) {
    return repository.register(name, email, password);
  }
}