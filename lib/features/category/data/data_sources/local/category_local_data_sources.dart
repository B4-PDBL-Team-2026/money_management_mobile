import 'dart:convert';

import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/category/data/models/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const _categoriesKey = 'categories';

  CategoryLocalDataSource(this.sharedPreferences);

  List<CategoryModel> getCategories() {
    final categoriesJson = sharedPreferences.getStringList(_categoriesKey);

    if (categoriesJson == null) {
      throw CacheNotFoundException();
    }

    return categoriesJson
        .map((json) => CategoryModel.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> storeCategories(List<CategoryModel> categories) async {
    final categoriesJson = categories
        .map(
          (category) => jsonEncode(
            CategoryModel(
              id: category.id,
              name: category.name,
              icon: category.icon,
              type: category.type,
            ).toJson(),
          ),
        )
        .toList();

    await sharedPreferences.setStringList(_categoriesKey, categoriesJson);
  }

  Future<void> clearCategories() async {
    await sharedPreferences.remove(_categoriesKey);
  }
}
