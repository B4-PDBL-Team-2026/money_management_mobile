import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/profile/data/data_sources/remote/fixed_cost_template_remote_data_source.dart';
import 'package:money_management_mobile/features/profile/data/models/fixed_cost_template_model.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_occurrence_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_template_entity.dart';
import 'package:money_management_mobile/features/profile/domain/repositories/fixed_cost_template_repository.dart';

@LazySingleton(as: FixedCostTemplateRepository)
class FixedCostTemplateRepositoryImpl implements FixedCostTemplateRepository {
  final FixedCostTemplateRemoteDataSource remoteDataSource;

  FixedCostTemplateRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<FixedCostOccurrenceEntity>> getFixedCostTemplate() async {
    final models = await remoteDataSource.getFixedCostTemplate();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> createFixedCostTemplate(FixedCostTemplateEntity payload) async {
    await remoteDataSource.createFixedCostTemplate(
      FixedCostTemplateModel.fromEntity(payload),
    );
  }

  @override
  Future<void> updateFixedCostTemplate(
    int fixedCostTemplateId,
    FixedCostTemplateEntity payload,
  ) async {
    await remoteDataSource.updateFixedCostTemplate(
      fixedCostTemplateId,
      FixedCostTemplateModel.fromEntity(payload),
    );
  }

  @override
  Future<void> deleteFixedCostTemplate(int fixedCostTemplateId) async {
    await remoteDataSource.deleteFixedCostTemplate(fixedCostTemplateId);
  }
}
