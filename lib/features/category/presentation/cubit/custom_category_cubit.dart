import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/core/constants/app_messages.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/category/domain/repositories/category_repository.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/custom_category_state.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

@injectable
class CustomCategoryCubit extends Cubit<CustomCategoryState> {
  final CategoryRepository _categoryRepository;

  CustomCategoryCubit(this._categoryRepository) : super(CustomCategoryInitial());

  Future<void> fetchCustomCategories() async {
    if (state is CustomCategoryLoading) return;

    emit(CustomCategoryLoading());

    try {
      final result = await _categoryRepository.getCustomCategories();
      emit(CustomCategoryLoaded(result));
    } on NetworkException catch (e) {
      emit(CustomCategoryErrorAndRetry(e.message, fetchCustomCategories));
    } on CacheNotFoundException catch (e) {
      emit(CustomCategoryErrorAndRetry(e.message, fetchCustomCategories));
    } on UnauthorizedException catch (e) {
      emit(CustomCategoryError(e.message));
    } on ServerException catch (e) {
      emit(CustomCategoryError(e.message));
    } on UnexpectedException catch (e) {
      emit(CustomCategoryError(e.message));
    } catch (e) {
      if (kDebugMode) {
        emit(CustomCategoryError('Ada kendala: ${e.toString()}'));
      } else {
        emit(CustomCategoryError(AppMessages.unknownError));
      }
    }
  }

  Future<bool> addCustomCategory({
    required String name,
    required String icon,
    required TransactionType type,
  }) async {
    try {
      await _categoryRepository.createCustomCategory(
        name: name,
        icon: icon,
        type: type,
      );
      await fetchCustomCategories();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCustomCategory({
    required int categoryId,
    required String name,
    required String icon,
    required TransactionType type,
  }) async {
    try {
      await _categoryRepository.updateCustomCategory(
        categoryId: categoryId,
        name: name,
        icon: icon,
        type: type,
      );
      await fetchCustomCategories();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteCustomCategory(int categoryId) async {
    try {
      await _categoryRepository.deleteCustomCategory(categoryId);
      await fetchCustomCategories();
      return true;
    } catch (e) {
      return false;
    }
  }
}
