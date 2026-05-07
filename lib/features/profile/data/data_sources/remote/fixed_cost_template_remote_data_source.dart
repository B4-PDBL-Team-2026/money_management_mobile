import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/profile/data/models/fixed_cost_occurrence_model.dart';
import 'package:money_management_mobile/features/profile/data/models/fixed_cost_template_model.dart';

@LazySingleton()
class FixedCostTemplateRemoteDataSource {
  final Dio dio;
  final _log = Logger('FixedCostTemplateRemoteDataSource');

  FixedCostTemplateRemoteDataSource(this.dio);

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
      final rawData = response.data['data'] as List<dynamic>? ?? [];

      return rawData
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .map((item) {
        // If backend returns a template object (no dueDate, category may be null),
        // convert it into the shape expected by FixedCostOccurrenceModel.fromJson
        final hasCycle = item.containsKey('cycleType') || item.containsKey('cycle_type') || item.containsKey('cycle');

        if (hasCycle) {
          final rawId = item['id'];
          final parsedId = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '') ?? 0;

          final amountRaw = item['amount']?.toString() ?? '0';

          Map<String, dynamic>? categoryMap;
          final rawCategory = item['category'];
          if (rawCategory is Map && rawCategory.containsKey('id')) {
            categoryMap = {'id': rawCategory['id'], 'name': rawCategory['name']};
          } else if (item.containsKey('categoryId') || item.containsKey('category_id')) {
            final rawCategoryId = item['categoryId'] ?? item['category_id'];
            categoryMap = {'id': rawCategoryId};
          } else {
            categoryMap = null;
          }

          final cycleType = item['cycleType'] ?? item['cycle_type'] ?? item['cycle'] ?? '-';
          final dueDay = item['dueDay'] ?? item['due_day'];

          final occurrenceMap = <String, dynamic>{
            'id': parsedId,
            'fixedCostTemplateId': parsedId,
            'name': item['name'] ?? '-',
            'amount': amountRaw,
            'category': categoryMap,
            'cycleType': cycleType,
            'dueDay': dueDay,
            'status': item['status'] ?? 'pending',
          };

          return FixedCostOccurrenceModel.fromJson(occurrenceMap);
        }

        return FixedCostOccurrenceModel.fromJson(item);
      }).toList();
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

  Future<void> createFixedCostTemplate(FixedCostTemplateModel payload) async {
    if (AppEnv.useMockApi) {
      _log.info(
        'USE_MOCK_API enabled, returning dummy create fixed cost template response',
      );
      await Future.delayed(const Duration(seconds: 1));

      if (payload.name.toLowerCase() == 'error') {
        throw ServerException('Simulasi gagal membuat fixed cost template');
      }

      return;
    }

    try {
      await dio.post('/fixed-costs', data: payload.toJson());
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(
        e,
        _log,
        'Create Fixed Cost Template',
      );
    } catch (e) {
      _log.severe('Unexpected error while creating fixed cost template', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat menambahkan fixed cost template',
      );
    }
  }

  Future<void> updateFixedCostTemplate(
    int fixedCostTemplateId,
    FixedCostTemplateModel payload,
  ) async {
    if (AppEnv.useMockApi) {
      _log.info(
        'USE_MOCK_API enabled, returning dummy update fixed cost template response',
      );
      await Future.delayed(const Duration(seconds: 1));

      if (payload.name.toLowerCase() == 'error') {
        throw ServerException('Simulasi gagal mengubah fixed cost template');
      }

      return;
    }

    try {
      await dio.patch(
        '/fixed-costs/$fixedCostTemplateId',
        data: payload.toJson(),
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(
        e,
        _log,
        'Update Fixed Cost Template',
      );
    } catch (e) {
      _log.severe('Unexpected error while updating fixed cost template', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat mengubah fixed cost template',
      );
    }
  }

  Future<void> deleteFixedCostTemplate(int fixedCostTemplateId) async {
    if (AppEnv.useMockApi) {
      _log.info(
        'USE_MOCK_API enabled, returning dummy delete fixed cost template response',
      );
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    try {
      await dio.delete('/fixed-costs/$fixedCostTemplateId');
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(
        e,
        _log,
        'Delete Fixed Cost Template',
      );
    } catch (e) {
      _log.severe('Unexpected error while deleting fixed cost template', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat menghapus fixed cost template',
      );
    }
  }
}
