import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/category/data/models/category_model.dart';
import 'package:money_management_mobile/features/category/domain/repositories/category_repository.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/category.dart';

class CategoryRemoteDataSource {
  final Dio dio;
  final _log = Logger('CategoryRemoteDataSource');

  CategoryRemoteDataSource(this.dio);

  Future<List<CategoryEntity>> getCategories() async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(seconds: 1));

      return [
        CategoryEntity(
          id: 1,
          name: 'Gaji',
          icon: 'wallet',
          type: TransactionType.income,
        ),
        CategoryEntity(
          id: 2,
          name: 'Makanan',
          icon: 'bowl_food',
          type: TransactionType.expense,
        ),
        CategoryEntity(
          id: 3,
          name: 'Transportasi',
          icon: 'taxi',
          type: TransactionType.expense,
        ),
      ];
    }

    try {
      final response = await dio.get('/category/system');
      final data = response.data['data'] as List<dynamic>;

      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, 'getCategories');
    } catch (e) {
      _log.severe('Unexpected fetch categories error', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat mengambil kategori',
      );
    }
  }
}
