import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/category/data/models/category_model.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

@LazySingleton()
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
          isSystem: true,
        ),
        CategoryModel(
          id: 2,
          name: 'Makanan',
          icon: 'bowl_food',
          isSystem: false,
          type: TransactionType.expense,
        ),
        CategoryModel(
          id: 3,
          name: 'Transportasi',
          icon: 'taxi',
          isSystem: false,
          type: TransactionType.expense,
        ),
      ];
    }

    try {
      final response = await dio.get('/category/system');
      final data = response.data['data'] as List<dynamic>;

      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, 'getSystemCategories');
    } catch (e) {
      _log.severe('Unexpected fetch system categories error', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat mengambil kategori',
      );
    }
  }

  Future<List<CategoryModel>> getCustomCategories() async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(milliseconds: 500));
      return [];
    }

    try {
      final response = await dio.get('/category/custom');
      final data = response.data['data'] as List<dynamic>;
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, 'getCustomCategories');
    } catch (e) {
      _log.severe('Unexpected fetch custom categories error', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat mengambil kategori kustom',
      );
    }
  }

  Future<CategoryModel> createCustomCategory({
    required String name,
    required String icon,
    required TransactionType type,
  }) async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(milliseconds: 500));
      return CategoryModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: name,
        icon: icon,
        type: type,
        isSystem: false,
      );
    }

    try {
      final response = await dio.post(
        '/category/custom',
        data: {
          'name': name,
          'icon': icon,
          'type': type.value,
        },
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return CategoryModel.fromJson(data);
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, 'createCustomCategory');
    } catch (e) {
      _log.severe('Unexpected create custom category error', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat membuat kategori kustom',
      );
    }
  }

  Future<CategoryModel> updateCustomCategory({
    required int categoryId,
    String? name,
    String? icon,
    TransactionType? type,
  }) async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(milliseconds: 500));
      return CategoryModel(
        id: categoryId,
        name: name ?? 'Updated',
        icon: icon ?? 'question',
        type: type ?? TransactionType.expense,
        isSystem: false,
      );
    }

    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (icon != null) data['icon'] = icon;
      if (type != null) data['type'] = type.value;

      final response = await dio.patch(
        '/category/custom/$categoryId',
        data: data,
      );
      final responseData = response.data['data'] as Map<String, dynamic>;
      return CategoryModel.fromJson(responseData);
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, 'updateCustomCategory');
    } catch (e) {
      _log.severe('Unexpected update custom category error', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat memperbarui kategori kustom',
      );
    }
  }

  Future<void> deleteCustomCategory(int categoryId) async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(milliseconds: 500));
      return;
    }

    try {
      await dio.delete('/category/custom/$categoryId');
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, 'deleteCustomCategory');
    } catch (e) {
      _log.severe('Unexpected delete custom category error', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat menghapus kategori kustom',
      );
    }
  }
}
