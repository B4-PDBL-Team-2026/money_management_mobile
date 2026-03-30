import 'package:money_management_mobile/features/profile/data/data_sources/remote/profile_remote_data_source.dart';
import 'package:money_management_mobile/features/profile/data/models/fixed_cost_model.dart';
import 'package:money_management_mobile/features/profile/data/models/financial_profile_model.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_occurrence_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> submitFinancialProfile(FinancialProfileEntity payload) async {
    await remoteDataSource.submitFinancialProfile(
      FinancialProfileModel.fromEntity(payload),
    );
  }

  @override
  Future<List<FixedCostOccurrenceEntity>> getFixedCostOccurrences() async {
    final models = await remoteDataSource.getFixedCostOccurrences();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> createFixedCost(FixedCostEntity payload) async {
    await remoteDataSource.createFixedCost(FixedCostModel.fromEntity(payload));
  }
}
