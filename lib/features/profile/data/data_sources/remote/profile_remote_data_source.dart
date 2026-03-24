import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/profile/data/models/financial_profile_model.dart';

class ProfileRemoteDataSource {
  final Dio dio;
  final _log = Logger('ProfileRemoteDataSource');

  ProfileRemoteDataSource(this.dio);

  Future<void> submitFinancialProfile(FinancialProfileModel payload) async {
    if (AppEnv.useMockApi) {
      _log.info('USE_MOCK_API enabled, returning dummy onboarding response');
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    try {
      await dio.post('/onboarding', data: payload.toJson());
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, 'Register');
    } catch (e) {
      _log.severe('Unexpected register error', e);
      throw UnexpectedException('Terjadi kesalahan sistem saat registrasi');
    }
  }
}
