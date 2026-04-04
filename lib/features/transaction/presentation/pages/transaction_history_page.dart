import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/constants/global_constant.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_history_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_history_state.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/category_dialog_content.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/month_year_dialog_content.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/summary_card.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/transaction_components.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/transaction_history_item.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistoryPage> {
  final _searchDebouncer = Debouncer(milliseconds: 500);
  final _searchController = TextEditingController();

  late final CategoryEntity _defaultCategory;

  int? _month;
  int? _year;
  late CategoryEntity _selectedCategory;
  int totalPengeluaran = 0;
  int totalPemasukan = 0;

  @override
  void initState() {
    super.initState();

    _defaultCategory = CategoryEntity(
      id: 0,
      name: 'Semua',
      icon: 'default',
      type: TransactionType.expense,
      categoryType: RealCategoryType.system,
    );

    _month = null;
    _year = null;

    _selectedCategory = _defaultCategory;
  }

  void _getFreshTransactionHistory({
    String? search,
    CategoryEntity? categoryEntity,
  }) {
    final categoryToUse = categoryEntity ?? _selectedCategory;

    context.read<TransactionHistoryCubit>().getFreshTransactionHistory(
      month: _month,
      year: _year,
      categoryEntity: categoryToUse.id != 0 ? categoryToUse : null,
      search: search ?? _searchController.text,
    );
  }

  void _loadMoreTransactionHistory(int page) {
    context.read<TransactionHistoryCubit>().loadMoreTransactionHistory(
      page: page,
      month: _month,
      year: _year,
      categoryEntity: _selectedCategory.id != 0 ? _selectedCategory : null,
      search: _searchController.text,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gohan,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing6),
          child: BlocConsumer<TransactionHistoryCubit, TransactionHistoryState>(
            listener: (context, state) {
              if (state is TransactionHistorySuccess) {
                totalPengeluaran = state.transactionHistory
                    .where((item) => item.type == TransactionType.expense)
                    .fold(0, (sum, item) => sum + item.amount);

                totalPemasukan = state.transactionHistory
                    .where((item) => item.type == TransactionType.income)
                    .fold(0, (sum, item) => sum + item.amount);
              }

              if (state is TransactionHistoryError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.danger100,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Riwayat Transaksi',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(color: AppColors.primary),
                      ),

                      AnimatedRotation(
                        duration: const Duration(milliseconds: 500),
                        turns: state is TransactionHistoryLoading ? 1 : 0,
                        child: IconButton(
                          onPressed: () {
                            if (state is! TransactionHistoryLoading) {
                              context
                                  .read<TransactionHistoryCubit>()
                                  .getFreshTransactionHistory();
                            }
                          },
                          icon: PhosphorIcon(
                            PhosphorIconsRegular.arrowClockwise,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.spacing6),
                  _buildFilterSection(),
                  const SizedBox(height: AppSizes.spacing3),

                  if (state is TransactionHistorySuccess) ...[
                    _buildSummarySection(),
                    const SizedBox(height: AppSizes.spacing3),
                  ],

                  if (state is TransactionHistoryLoading) ...[
                    _buildLoadingState(),
                  ] else if (state is TransactionHistorySuccess) ...[
                    if (state.totalItems == 0) ...[
                      Expanded(child: const EmptyState()),
                    ] else ...[
                      Expanded(
                        child: state.transactionHistory.isNotEmpty
                            ? _buildDataList(state)
                            : const EmptyState(),
                      ),
                    ],
                  ] else if (state is TransactionHistoryError) ...[
                    _buildErrorState(context),
                  ] else ...[
                    Expanded(child: const EmptyState()),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  SizedBox _buildLoadingState() {
    return SizedBox(
      height: 350,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text('Memuat data transaksi...'),
          ],
        ),
      ),
    );
  }

  SizedBox _buildErrorState(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Gagal memuat data transaksi'),
            const SizedBox(height: AppSizes.spacing4),
            AppButton(
              width: 120,
              text: 'Coba Lagi',
              onPressed: () {
                context
                    .read<TransactionHistoryCubit>()
                    .getFreshTransactionHistory();
              },
              variant: AppButtonVariant.ghost,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return AppContainerCard(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          AppTextField(
            controller: _searchController,
            hint: 'Cari nama transaksi...',
            withBorder: false,
            prefixIcon: PhosphorIcon(
              PhosphorIconsRegular.magnifyingGlass,
              color: Colors.grey,
            ),
            onChanged: (value) {
              if (value.isEmpty || value.length >= 3) {
                _searchDebouncer.run(_getFreshTransactionHistory);
              }
            },
          ),
          const SizedBox(height: AppSizes.spacing3),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: _month == null && _year == null
                      ? 'Semua Hari'
                      : _month == null
                      ? 'Semua Bulan $_year'
                      : '${GlobalConstant.monthMapping[_month]} $_year',
                  leadingIcon: PhosphorIconsRegular.calendarBlank,
                  onPressed: _openMonthYearPicker,
                  variant: AppButtonVariant.ghost,
                  fontSize: 14,
                  overflow: true,
                ),
              ),
              const SizedBox(width: AppSizes.spacing3),
              Expanded(
                child: AppButton(
                  text: _selectedCategory.name,
                  leadingIcon:
                      GlobalConstant.categoryIconsMapping[_selectedCategory
                          .icon] ??
                      PhosphorIconsRegular.squaresFour,
                  onPressed: _openCategoryPicker,
                  variant: AppButtonVariant.ghost,
                  fontSize: 14,
                  overflow: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: 'Total Pengeluaran',
            value: 'Rp ${CurrencyFormatter.format(totalPengeluaran)}',
          ),
        ),
        const SizedBox(width: AppSizes.spacing3),
        Expanded(
          child: SummaryCard(
            title: 'Total Pemasukan',
            value: 'Rp ${CurrencyFormatter.format(totalPemasukan)}',
          ),
        ),
      ],
    );
  }

  Widget _buildDataList(TransactionHistorySuccess state) {
    final transactionList = state.transactionHistory;

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: transactionList.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSizes.spacing3),
      itemBuilder: (context, index) {
        final item = transactionList[index];
        final previousItem = index > 0 ? transactionList[index - 1] : null;

        bool showHeader =
            previousItem == null ||
            item.transactionAt.day != previousItem.transactionAt.day ||
            item.transactionAt.month != previousItem.transactionAt.month ||
            item.transactionAt.year != previousItem.transactionAt.year;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) ...[
              const SizedBox(height: AppSizes.spacing3),
              DateHeader(date: item.transactionAt),
              const SizedBox(height: AppSizes.spacing3),
            ],
            GestureDetector(
              onTap: () {
                context.push('${AppRouter.transactionDetailBase}/${item.id}');
              },
              child: TransactionHistoryItem(transaction: item),
            ),

            if (index == transactionList.length - 1) ...[
              const SizedBox(height: AppSizes.spacing6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total transaksi: ${state.totalItems}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  if (transactionList.length < state.totalItems) ...[
                    const SizedBox(width: AppSizes.spacing3),
                    Text(
                      'Total transaksi tersisa: ${state.totalItems - transactionList.length}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),

              if (state.currentPage < state.totalPages) ...[
                const SizedBox(height: AppSizes.spacing3),
                AppButton(
                  isLoading: state.isLoadingMore,
                  text: 'Muat Lebih Banyak',
                  onPressed: () {
                    if (!state.isLoadingMore) {
                      _loadMoreTransactionHistory(state.currentPage + 1);
                    }
                  },
                  variant: AppButtonVariant.ghost,
                ),
              ],
            ],
          ],
        );
      },
    );
  }

  Future<void> _openMonthYearPicker() async {
    // tuple: (month, year)
    final result = await showDialog<(int?, int?)>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: MonthYearDialogContent(
          initialMonth: _month ?? DateTime.now().month,
          initialYear: _year ?? DateTime.now().year,
          initialSelectedMonth: _month,
          initialSelectedYear: _year,
          startYear: 2024,
        ),
      ),
    );

    if (result != null) {
      final month = result.$1;
      final year = result.$2;
      setState(() {
        _month = month;
        _year = year;
      });

      _getFreshTransactionHistory();
    }
  }

  Future<void> _openCategoryPicker() async {
    final result = await showDialog<CategoryEntity>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: CategoryDialogContent(
          defaultCategory: _defaultCategory,
          selectedCategory: _selectedCategory,
        ),
      ),
    );

    if (result != null) {
      setState(() => _selectedCategory = result);
      _getFreshTransactionHistory();
    }
  }
}
