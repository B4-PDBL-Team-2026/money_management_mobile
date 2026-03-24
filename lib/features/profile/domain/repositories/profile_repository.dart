import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

abstract class ProfileRepository {
  Future<void> submitFinancialProfile(FinancialProfileEntity payload);
}
