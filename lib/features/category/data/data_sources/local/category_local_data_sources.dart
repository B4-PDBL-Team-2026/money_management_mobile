import 'dart:convert';

import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/category/data/models/category_model.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const _systemCategoriesKey = 'system_categories';

  CategoryLocalDataSource(this.sharedPreferences);

  List<CategoryModel> getSystemCategories() {
    final categoriesJson = sharedPreferences.getStringList(
      _systemCategoriesKey,
    );

    if (categoriesJson == null) {
      throw CacheNotFoundException();
    }

    return categoriesJson
        .map(
          (json) =>
              CategoryModel.fromJson(jsonDecode(json), RealCategoryType.system),
        )
        .toList();
  }

  Future<void> storeSystemCategories(List<CategoryModel> categories) async {
    final categoriesJson = categories
        .map((category) => jsonEncode(category.toJson()))
        .toList();

    await sharedPreferences.setStringList(_systemCategoriesKey, categoriesJson);
  }

  Future<void> clearSystemCategories() async {
    await sharedPreferences.remove(_systemCategoriesKey);
  }
}
