import 'package:money_management_mobile/features/transaction/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories();
}

class CategoryEntity {
  final int id;
  final String name;
  final String icon;
  final TransactionType type;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
  });
}
