import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';

// TODO: untuk sementara biarkan, gunakan ini di masa depan untuk menyimpan query
class TransactionHistoryQueryState {
  final int? currentPage;
  final String? search;
  final CategoryEntity? selectedCategory;
  final int? selectedMonth;
  final int? selectedYear;

  const TransactionHistoryQueryState({
    this.currentPage,
    this.search,
    this.selectedCategory,
    this.selectedMonth,
    this.selectedYear,
  });

  factory TransactionHistoryQueryState.initial() {
    final now = DateTime.now();

    return TransactionHistoryQueryState(
      currentPage: 1,
      search: null,
      selectedCategory: null,
      selectedMonth: now.month,
      selectedYear: now.year,
    );
  }

  TransactionHistoryQueryState copyWith({
    int? currentPage,
    String? search,
    CategoryEntity? selectedCategory,
    int? selectedMonth,
    int? selectedYear,
  }) {
    return TransactionHistoryQueryState(
      currentPage: currentPage ?? this.currentPage,
      search: search ?? this.search,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }
}
