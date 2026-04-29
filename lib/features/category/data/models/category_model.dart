import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.type,
    required super.isSystem,
    super.createdAt,
    super.updatedAt,
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
      userId: json['user_id'] as int?,
      createdAt: TimezoneConverter.toLocal(json['created_at'] as String),
      updatedAt: TimezoneConverter.toLocal(json['updated_at'] as String),
      isSystem: json['is_system'] as bool,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      userId: userId,
      name: name,
      icon: icon,
      type: type,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSystem: isSystem,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'type': type.value,
      'user_id': userId,
      'is_system': isSystem,
      'created_at': createdAt != null
          ? TimezoneConverter.toUtcString(createdAt!)
          : null,
      'updated_at': updatedAt != null
          ? TimezoneConverter.toUtcString(updatedAt!)
          : null,
    };
  }
}
