import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.type,
    required super.categoryType,
  });

  factory CategoryModel.fromJson(
    Map<String, dynamic> json,
    RealCategoryType categoryType,
  ) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
      type: json['type'] as String == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      categoryType: categoryType,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      icon: icon,
      type: type,
      categoryType: categoryType,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'icon': icon, 'type': type.value};
  }
}
