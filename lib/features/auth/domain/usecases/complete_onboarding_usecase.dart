import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';

class CompleteOnboardingUseCase {
  final AuthRepository repository;

  CompleteOnboardingUseCase(this.repository);

  Future<(UserEntity, String)> execute() async {
    final savedSession = repository.getSavedSession();

    if (savedSession == null) {
      throw UnexpectedException('Sesi login tidak ditemukan');
    }

    final (user, token, _) = savedSession;

    await repository.saveSession(user, token, requiresOnboarding: false);

    return (user, token);
  }
}
