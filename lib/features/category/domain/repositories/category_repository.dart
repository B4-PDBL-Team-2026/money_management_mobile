import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<void> clearCategories();
}
