import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_occurrence_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

abstract class ProfileRepository {
  Future<void> submitFinancialProfile(FinancialProfileEntity payload);

  Future<List<FixedCostOccurrenceEntity>> getFixedCostOccurrences();
}
