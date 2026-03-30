import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/profile/data/models/fixed_cost_model.dart';
import 'package:money_management_mobile/features/profile/data/models/fixed_cost_occurrence_model.dart';
import 'package:money_management_mobile/features/profile/data/models/financial_profile_model.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_occurrence_entity.dart';

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

  Future<List<FixedCostOccurrenceModel>> getFixedCostOccurrences() async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(seconds: 1));

      return [
        FixedCostOccurrenceModel(
          fixedCostTemplateId: 1,
          id: 1,
          name: 'WiFi',
          amountRaw: '100000',
          categoryId: 3,
          cycleType: 'weekly',
          dueDate: DateTime.now().add(const Duration(days: 2)),
          status: FixedCostOccurrenceStatus.pending,
        ),
        FixedCostOccurrenceModel(
          fixedCostTemplateId: 2,
          id: 2,
          name: 'Asuransi',
          amountRaw: '500000',
          categoryId: 4,
          cycleType: 'monthly',
          dueDate: DateTime.now().add(const Duration(days: 7)),
          status: FixedCostOccurrenceStatus.paid,
        ),
      ];
    }

    try {
      final response = await dio.get('/fixed-costs/occurrences');
      final rawData = response.data['data'] as List<dynamic>? ?? [];

      return rawData
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .map(FixedCostOccurrenceModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(
        e,
        _log,
        'Get Fixed Cost Occurrences',
      );
    } catch (e) {
      _log.severe('Unexpected error while fetching fixed cost occurrences', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat mengambil fixed cost occurrences',
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
