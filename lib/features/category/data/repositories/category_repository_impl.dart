import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/category/data/data_sources/remote/category_remote_data_sources.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/category/domain/repositories/category_repository.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

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

  @override
  Future<List<CategoryEntity>> getCustomCategories() async {
    final categories = await _remoteDataSource.getCustomCategories();
    return categories.map((category) => category.toEntity()).toList();
  }

  @override
  Future<CategoryEntity> createCustomCategory({
    required String name,
    required String icon,
    required TransactionType type,
  }) async {
    final category = await _remoteDataSource.createCustomCategory(
      name: name,
      icon: icon,
      type: type,
    );
    return category.toEntity();
  }

  @override
  Future<CategoryEntity> updateCustomCategory({
    required int categoryId,
    String? name,
    String? icon,
    TransactionType? type,
  }) async {
    final category = await _remoteDataSource.updateCustomCategory(
      categoryId: categoryId,
      name: name,
      icon: icon,
      type: type,
    );
    return category.toEntity();
  }

  @override
  Future<void> deleteCustomCategory(int categoryId) async {
    await _remoteDataSource.deleteCustomCategory(categoryId);
  }
}
