import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/features/category/domain/repositories/category_repository.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_state.dart';
import 'package:event_bus/event_bus.dart';

@LazySingleton()
class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _categoryRepository;
  final EventBus _eventBus;
  late final StreamSubscription<dynamic> _refreshSubscription;

  CategoryCubit(this._categoryRepository, this._eventBus)
    : super(CategoryInitial()) {
    _refreshSubscription = _eventBus
        .on<RefreshCategoriesEvent>()
        .listen((_) => fetchCategories());
  }

  Future<void> fetchCategories() async {
    if (state is CategoryLoading) return;
    if (state is CategoryLoaded) return;

    emit(CategoryLoading());

    try {
      final result = await _categoryRepository.getCategories();
      emit(CategoryLoaded(result));
    } on NetworkException catch (e) {
      emit(CategoryErrorAndRetry(e.message, fetchCategories));
    } on CacheNotFoundException catch (e) {
      emit(CategoryErrorAndRetry(e.message, fetchCategories));
    } on ServerException catch (e) {
      emit(CategoryError(e.message));
    } on UnexpectedException catch (e) {
      emit(CategoryError(e.message));
    } catch (e) {
      if (kDebugMode) {
        emit(CategoryError('Terjadi kesalahan: ${e.toString()}'));
      } else {
        emit(
          CategoryError(
            'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
    }
  }

  Future<void> clearCategories() async {
    await _categoryRepository.clearCategories();
    emit(CategoryInitial());
  }

  @override
  Future<void> close() {
    _refreshSubscription.cancel();
    return super.close();
  }
}
