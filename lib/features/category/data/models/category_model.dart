import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.type,
    required super.isSystem,
    super.userId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
      type: json['type'] as String == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      userId: json['userId'] as int?,
      isSystem: json['isSystem'] as bool,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      userId: userId,
      name: name,
      icon: icon,
      type: type,
      isSystem: isSystem,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'type': type.value,
      'userId': userId,
      'isSystem': isSystem,
    };
  }
}
