import 'package:flutter/widgets.dart';
import 'package:money_management_mobile/features/category/domain/repositories/category_repository.dart';

sealed class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryEntity> categories;

  CategoryLoaded(this.categories);
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}

class CategoryErrorAndRetry extends CategoryState {
  final String message;
  final VoidCallback onRetry;

  CategoryErrorAndRetry(this.message, this.onRetry);
}
