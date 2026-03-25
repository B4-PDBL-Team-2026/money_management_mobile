import 'package:money_management_mobile/features/category/domain/repositories/category_repository.dart';

class GetCategoriesUsecase {
  final CategoryRepository repository;

  GetCategoriesUsecase(this.repository);

  Future<List<CategoryEntity>> execute() async {
    return await repository.getCategories();
  }
}
