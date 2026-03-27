import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/repositories/profile_repository.dart';

class SubmitFinancialProfileUseCase {
  final ProfileRepository repository;

  SubmitFinancialProfileUseCase(this.repository);

  Future<void> execute(FinancialProfileEntity payload) {
    return repository.submitFinancialProfile(payload);
  }
}
