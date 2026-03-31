import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

class RequestEmailVerificationUseCase {
  final AuthRepository repository;

  RequestEmailVerificationUseCase(this.repository);

  Future<String> execute() {
    return repository.requestEmailVerification();
  }
}
