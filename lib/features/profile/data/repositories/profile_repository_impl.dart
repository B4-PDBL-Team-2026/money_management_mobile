import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/profile/data/data_sources/remote/profile_remote_data_source.dart';
import 'package:money_management_mobile/features/profile/data/models/financial_profile_model.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/repositories/profile_repository.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> submitFinancialProfile(FinancialProfileEntity payload) async {
    await remoteDataSource.submitFinancialProfile(
      FinancialProfileModel.fromEntity(payload),
    );
  }
}
