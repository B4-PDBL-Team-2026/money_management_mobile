import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

class SendPasswordResetEmailUseCase {
  final AuthRepository repository;

  SendPasswordResetEmailUseCase(this.repository);

  Future<String> execute({required String email}) {
    return repository.sendPasswordResetEmail(email);
  }
}
