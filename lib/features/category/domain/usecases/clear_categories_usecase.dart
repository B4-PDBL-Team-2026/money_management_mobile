import 'package:money_management_mobile/features/category/domain/repositories/category_repository.dart';

class ClearCategoriesUsecase {
  final CategoryRepository categoryRepository;

  ClearCategoriesUsecase(this.categoryRepository);

  Future<void> execute() async {
    await categoryRepository.clearCategories();
  }
}
