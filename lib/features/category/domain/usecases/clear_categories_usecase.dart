import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/category/domain/repositories/category_repository.dart';

@LazySingleton()
class ClearCategoriesUsecase {
  final CategoryRepository categoryRepository;

  ClearCategoriesUsecase(this.categoryRepository);

  Future<void> execute() async {
    await categoryRepository.clearCategories();
  }
}
