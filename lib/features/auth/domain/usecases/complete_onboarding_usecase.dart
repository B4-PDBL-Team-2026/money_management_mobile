import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

class CompleteOnboardingUseCase {
  final AuthRepository repository;

  CompleteOnboardingUseCase(this.repository);

  Future<void> execute() async {
    await repository.updateRequiresOnboarding(false);
  }
}
