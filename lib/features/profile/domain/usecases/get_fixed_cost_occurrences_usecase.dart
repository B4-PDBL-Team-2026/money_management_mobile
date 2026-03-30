import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_occurrence_entity.dart';
import 'package:money_management_mobile/features/profile/domain/repositories/profile_repository.dart';

class GetFixedCostOccurrencesUseCase {
  final ProfileRepository repository;

  GetFixedCostOccurrencesUseCase(this.repository);

  Future<List<FixedCostOccurrenceEntity>> execute() {
    return repository.getFixedCostOccurrences();
  }
}
