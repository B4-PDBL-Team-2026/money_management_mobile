import 'package:money_management_mobile/features/profile/domain/repositories/profile_repository.dart';

class DeleteFixedCostUseCase {
  final ProfileRepository repository;

  DeleteFixedCostUseCase(this.repository);

  Future<void> execute(int fixedCostTemplateId) {
    return repository.deleteFixedCost(fixedCostTemplateId);
  }
}
