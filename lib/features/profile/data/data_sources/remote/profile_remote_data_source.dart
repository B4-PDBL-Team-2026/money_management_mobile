import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/profile/data/models/financial_profile_model.dart';

@LazySingleton()
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
      throw ErrorHandler.handleRemoteException(e, _log, 'submitFinancialProfile');
    } catch (e) {
      _log.severe('Unexpected submitFinancialProfile error', e);
      throw UnexpectedException('Ada kendala pas simpan profil keuangan. Coba lagi ya.');
    }
  }

  Future<void> updateBudgetLimits({
    required int safetyCeiling,
    required int safetyFlooring,
  }) async {
    if (AppEnv.useMockApi) {
      _log.info('USE_MOCK_API enabled, simulating budget limits update success');
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    try {
      await dio.patch('/settings/dailyLimit', data: {
        'flooringLimit': safetyFlooring,
        'ceilingLimit': safetyCeiling,
        'safetyFlooring': safetyFlooring,
        'safetyCeiling': safetyCeiling,
      });
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, 'updateBudgetLimits');
    } catch (e) {
      _log.severe('Unexpected updateBudgetLimits error', e);
      throw UnexpectedException('Ada kendala pas simpan perubahan budget harian. Coba lagi ya.');
    }
  }
}
