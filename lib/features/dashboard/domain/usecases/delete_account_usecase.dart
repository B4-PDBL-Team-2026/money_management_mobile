import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

class DeleteAccountUseCase {
  final AuthRepository _repository;

  DeleteAccountUseCase(this._repository);

  Future<void> call(String password) async {
    await _repository.deleteAccount(password);
  }
}
