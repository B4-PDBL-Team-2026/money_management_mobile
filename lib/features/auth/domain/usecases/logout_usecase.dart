import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> execute() {
    return repository.clearSession();
  }
}