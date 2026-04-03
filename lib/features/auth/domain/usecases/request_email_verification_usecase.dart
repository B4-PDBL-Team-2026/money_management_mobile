import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

@Injectable()
class RequestEmailVerificationUseCase {
  final AuthRepository repository;

  RequestEmailVerificationUseCase(this.repository);

  Future<String> execute() {
    return repository.requestEmailVerification();
  }
}
