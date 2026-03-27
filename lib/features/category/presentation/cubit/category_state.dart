import 'package:flutter/widgets.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/category.dart';

sealed class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryEntity> categories;

  CategoryLoaded(this.categories);

  List<CategoryEntity> get expenseCategories =>
      categories.where((c) => c.type == TransactionType.expense).toList();
  List<CategoryEntity> get incomeCategories =>
      categories.where((c) => c.type == TransactionType.income).toList();
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
