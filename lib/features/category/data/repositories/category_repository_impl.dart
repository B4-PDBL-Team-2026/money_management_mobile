import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/category/data/data_sources/remote/category_remote_data_sources.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/category/domain/repositories/category_repository.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl extends CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;
  // final CategoryLocalDataSource _localDataSource;

  final List<CategoryEntity> _cachedCategories = [];

  CategoryRepositoryImpl(this._remoteDataSource /* , this._localDataSource */);

  @override
  Future<List<CategoryEntity>> getCategories() async {
    // TODO: stale cache masih jadi masalah

    // try {
    //   categories = _localDataSource.getSystemCategories();
    // } on CacheNotFoundException {
    //   categories = await _remoteDataSource.getSystemCategories();
    //   await _localDataSource.storeSystemCategories(categories);
    // } catch (e) {
    //   rethrow;
    // }

    if (_cachedCategories.isEmpty) {
      final categories = await _remoteDataSource.getSystemCategories();
      _cachedCategories.addAll(
        categories.map((category) => category.toEntity()),
      );
    }

    return _cachedCategories;
  }

  @override
  Future<void> clearCategories() async {
    // await _localDataSource.clearSystemCategories();
    _cachedCategories.clear();
  }
}
