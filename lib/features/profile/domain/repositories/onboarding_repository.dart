import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

abstract class OnboardingRepository {
  Future<void> submitOnboarding(FinancialProfileEntity payload);
}
