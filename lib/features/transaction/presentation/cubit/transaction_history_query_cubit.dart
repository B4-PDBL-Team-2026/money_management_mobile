import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_history_query_state.dart';

// TODO: untuk sementara biarkan, gunakan ini di masa depan
class TransactionHistoryQueryCubit extends Cubit<TransactionHistoryQueryState> {
  TransactionHistoryQueryCubit()
    : super(TransactionHistoryQueryState.initial());

  void updateSearch(String? search) {
    emit(state.copyWith(search: search, currentPage: 1));
  }

  void updateSelectedCategory(CategoryEntity? category) {
    emit(state.copyWith(selectedCategory: category, currentPage: 1));
  }

  void updateSelectedMonth(int? month) {
    emit(state.copyWith(selectedMonth: month, currentPage: 1));
  }

  void updateSelectedYear(int? year) {
    emit(state.copyWith(selectedYear: year, currentPage: 1));
  }

  void updateCurrentPage(int page) {
    emit(state.copyWith(currentPage: page));
  }

  void resetQuery() {
    emit(TransactionHistoryQueryState.initial());
  }
}
