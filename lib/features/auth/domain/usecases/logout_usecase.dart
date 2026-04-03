import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

@Injectable()
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> execute() {
    return repository.clearSession();
  }
}
