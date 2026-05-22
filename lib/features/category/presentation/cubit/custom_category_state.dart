import 'package:flutter/widgets.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';

sealed class CustomCategoryState {}

class CustomCategoryInitial extends CustomCategoryState {}

class CustomCategoryLoading extends CustomCategoryState {}

class CustomCategoryLoaded extends CustomCategoryState {
  final List<CategoryEntity> categories;

  CustomCategoryLoaded(this.categories);
}

class CustomCategoryError extends CustomCategoryState {
  final String message;
  CustomCategoryError(this.message);
}

class CustomCategoryErrorAndRetry extends CustomCategoryState {
  final String message;
  final VoidCallback onRetry;
  CustomCategoryErrorAndRetry(this.message, this.onRetry);
}
