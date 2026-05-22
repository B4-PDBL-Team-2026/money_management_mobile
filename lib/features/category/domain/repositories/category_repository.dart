import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<void> clearCategories();

  Future<List<CategoryEntity>> getCustomCategories();
  Future<CategoryEntity> createCustomCategory({
    required String name,
    required String icon,
    required TransactionType type,
  });
  Future<CategoryEntity> updateCustomCategory({
    required int categoryId,
    String? name,
    String? icon,
    TransactionType? type,
  });
  Future<void> deleteCustomCategory(int categoryId);
}
