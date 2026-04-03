import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

@Injectable()
class RestoreSessionUseCase {
  final AuthRepository repository;

  RestoreSessionUseCase(this.repository);

  (UserEntity, String, bool)? execute() {
    return repository.getSavedSession();
  }
}
