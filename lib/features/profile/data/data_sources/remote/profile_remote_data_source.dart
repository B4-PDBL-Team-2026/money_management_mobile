import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/profile/data/models/financial_profile_model.dart';
import 'package:money_management_mobile/features/profile/data/models/fixed_cost_model.dart';
import 'package:money_management_mobile/features/profile/data/models/fixed_cost_occurrence_model.dart';

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
      throw ErrorHandler.handleRemoteException(e, _log, 'Register');
    } catch (e) {
      _log.severe('Unexpected register error', e);
      throw UnexpectedException('Terjadi kesalahan sistem saat registrasi');
    }
  }

  Future<List<FixedCostOccurrenceModel>> getFixedCostTemplate() async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(seconds: 1));

      return [
        FixedCostOccurrenceModel.fromJson({
          'id': 1,
          'name': 'WiFi',
          'amount': '100000.00',
          'category_id': 3,
          'cycle_type': 'weekly',
          'due_day': 2,
          'is_active': true,
        }),
        FixedCostOccurrenceModel.fromJson({
          'id': 2,
          'name': 'Asuransi',
          'amount': '500000.00',
          'category_id': 4,
          'cycle_type': 'monthly',
          'due_day': 7,
          'is_active': true,
        }),
      ];
    }

    try {
      final response = await dio.get(
        '/fixed-costs',
        queryParameters: {'per_page': 100},
      );
      final rawEnvelope = response.data['data'] as Map<String, dynamic>? ?? {};
      final rawData = rawEnvelope['data'] as List<dynamic>? ?? [];

      return rawData
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .map(FixedCostOccurrenceModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(
        e,
        _log,
        'Get Fixed Cost Templates',
      );
    } catch (e) {
      _log.severe('Unexpected error while fetching fixed cost templates', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat mengambil fixed cost templates',
      );
    }
  }

  Future<void> createFixedCost(FixedCostModel payload) async {
    if (AppEnv.useMockApi) {
      _log.info(
        'USE_MOCK_API enabled, returning dummy create fixed cost response',
      );
      await Future.delayed(const Duration(seconds: 1));

      if (payload.name.toLowerCase() == 'error') {
        throw ServerException('Simulasi gagal membuat fixed cost');
      }

      return;
    }

    try {
      await dio.post('/fixed-costs', data: payload.toJson());
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, 'Create Fixed Cost');
    } catch (e) {
      _log.severe('Unexpected error while creating fixed cost', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat menambahkan fixed cost',
      );
    }
  }

  Future<void> updateFixedCost(
    int fixedCostTemplateId,
    FixedCostModel payload,
  ) async {
    if (AppEnv.useMockApi) {
      _log.info(
        'USE_MOCK_API enabled, returning dummy update fixed cost response',
      );
      await Future.delayed(const Duration(seconds: 1));

      if (payload.name.toLowerCase() == 'error') {
        throw ServerException('Simulasi gagal mengubah fixed cost');
      }

      return;
    }

    try {
      await dio.patch(
        '/fixed-costs/$fixedCostTemplateId',
        data: payload.toJson(),
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, 'Update Fixed Cost');
    } catch (e) {
      _log.severe('Unexpected error while updating fixed cost', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat mengubah fixed cost',
      );
    }
  }

  Future<void> deleteFixedCost(int fixedCostTemplateId) async {
    if (AppEnv.useMockApi) {
      _log.info(
        'USE_MOCK_API enabled, returning dummy delete fixed cost response',
      );
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    try {
      await dio.delete('/fixed-costs/$fixedCostTemplateId');
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, 'Delete Fixed Cost');
    } catch (e) {
      _log.severe('Unexpected error while deleting fixed cost', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat menghapus fixed cost',
      );
    }
  }
}
