import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_occurrence_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_template_entity.dart';

abstract class FixedCostTemplateRepository {
  Future<List<FixedCostOccurrenceEntity>> getFixedCostTemplate();

  Future<void> createFixedCostTemplate(FixedCostTemplateEntity payload);

  Future<void> updateFixedCostTemplate(
    int fixedCostTemplateId,
    FixedCostTemplateEntity payload,
  );

  Future<void> deleteFixedCostTemplate(int fixedCostTemplateId);
}
