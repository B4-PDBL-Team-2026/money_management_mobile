import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/repositories/onboarding_repository.dart';

class SubmitOnboardingUseCase {
  final OnboardingRepository repository;

  SubmitOnboardingUseCase(this.repository);

  Future<void> execute(FinancialProfileEntity payload) {
    return repository.submitOnboarding(payload);
  }
}
