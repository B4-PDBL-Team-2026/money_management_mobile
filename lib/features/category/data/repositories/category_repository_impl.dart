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
      try {
        final results = await Future.wait([
          _remoteDataSource.getSystemCategories(),
          _remoteDataSource.getCustomCategories(),
        ]);
        
        final systemCategories = results[0];
        final customCategories = results[1];

        _cachedCategories.addAll(
          systemCategories.map((category) => category.toEntity()),
        );
        _cachedCategories.addAll(
          customCategories.map((category) => category.toEntity()),
        );
      } catch (e) {
        // Fallback to fetch system categories only if custom categories fetch fails
        // because at app start, user is not logged in, fetching custom categories
        // will throw UnauthorizedException (401). If we rethrow, CategoryCubit
        // will emit CategoryError, showing an error state on the main dashboard.
        // So we fallback to only fetching system categories if user is not authorized yet.
        try {
          final systemCategories = await _remoteDataSource.getSystemCategories();
          _cachedCategories.addAll(
            systemCategories.map((category) => category.toEntity()),
          );
        } catch (_) {
          rethrow;
        }
      }
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
