import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/profile/data/data_sources/remote/onboarding_remote_data_source.dart';
import 'package:money_management_mobile/features/profile/data/models/onboarding_payload_model.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remoteDataSource;
  final _log = Logger('OnboardingRepositoryImpl');

  OnboardingRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> submitOnboarding(FinancialProfileEntity payload) async {
    _log.info('Submitting onboarding data to repository');

    try {
      await remoteDataSource.submitOnboarding(
        OnboardingPayloadModel.fromEntity(payload),
      );
      _log.info('Onboarding data submitted successfully');
    } on DioException catch (e) {
      ErrorHandler.handleRemoteException(e, _log, 'Submit onboarding');
      rethrow;
    } catch (e) {
      _log.severe('Unexpected onboarding repository error', e);
      throw UnexpectedException(e.toString());
    }
  }
}
