import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/category/data/data_sources/local/category_local_data_sources.dart';
import 'package:money_management_mobile/features/category/data/data_sources/remote/category_remote_data_sources.dart';
import 'package:money_management_mobile/features/category/data/models/category_model.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;
  final CategoryLocalDataSource _localDataSource;

  CategoryRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<CategoryEntity>> getCategories() async {
    late final List<CategoryModel> categories;

    try {
      categories = _localDataSource.getCategories();
    } on CacheNotFoundException {
      categories = await _remoteDataSource.getCategories();
      await _localDataSource.storeCategories(categories);
    } catch (e) {
      rethrow;
    }

    return categories.map((category) => category.toEntity()).toList();
  }

  @override
  Future<void> clearCategories() async {
    await _localDataSource.clearCategories();
  }
}
