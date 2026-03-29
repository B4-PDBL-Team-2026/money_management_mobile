import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/category/data/models/category_model.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class CategoryRemoteDataSource {
  final Dio dio;
  final _log = Logger('CategoryRemoteDataSource');

  CategoryRemoteDataSource(this.dio);

  Future<List<CategoryModel>> getSystemCategories() async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(seconds: 1));

      return [
        CategoryModel(
          id: 1,
          name: 'Gaji',
          icon: 'wallet',
          type: TransactionType.income,
          categoryType: RealCategoryType.system,
        ),
        CategoryModel(
          id: 2,
          name: 'Makanan',
          icon: 'bowl_food',
          type: TransactionType.expense,
          categoryType: RealCategoryType.system,
        ),
        CategoryModel(
          id: 3,
          name: 'Transportasi',
          icon: 'taxi',
          type: TransactionType.expense,
          categoryType: RealCategoryType.system,
        ),
      ];
    }

    try {
      final response = await dio.get('/category/system');
      final data = response.data['data'] as List<dynamic>;

      return data
          .map((json) => CategoryModel.fromJson(json, RealCategoryType.system))
          .toList();
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, 'getSystemCategories');
    } catch (e) {
      _log.severe('Unexpected fetch system categories error', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat mengambil kategori',
      );
    }
  }
}
