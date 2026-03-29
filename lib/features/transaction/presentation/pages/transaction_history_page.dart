import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_mobile/core/constants/global_constant.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_container_card.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_history_entity.dart';
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
  final _searchController = TextEditingController();

  late final CategoryEntity _defaultCategory;

  late int _month;
  late int _year;
  late CategoryEntity _selectedCategory;
  List<dynamic> transactionList = [];
  int totalPengeluaran = 0;
  int totalPemasukan = 0;

  @override
  void initState() {
    super.initState();

    context.read<TransactionHistoryCubit>().getTransactionHistory();

    _defaultCategory = CategoryEntity(
      id: 0,
      name: 'Semua',
      icon: 'default',
      type: TransactionType.expense,
      categoryType: RealCategoryType.system,
    );

    final now = DateTime.now();
    _month = now.month;
    _year = now.year;

    _selectedCategory = _defaultCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gohan,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spacing6,
            AppSizes.spacing6,
            AppSizes.spacing6,
            0,
          ),
          child: BlocConsumer<TransactionHistoryCubit, TransactionHistoryState>(
            listener: (context, state) {
              if (state is TransactionHistorySuccess) {
                transactionList = state.transactionHistory;

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
                                  .getTransactionHistory();
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
                  ],

                  if (state is TransactionHistoryLoading) ...[
                    SizedBox(
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
                    ),
                  ] else if (state is TransactionHistorySuccess) ...[
                    Expanded(
                      child: transactionList.isNotEmpty
                          ? _buildDataList(state.transactionHistory)
                          : const EmptyState(),
                    ),
                  ] else if (state is TransactionHistoryError) ...[
                    SizedBox(
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
                                    .getTransactionHistory();
                              },
                              variant: AppButtonVariant.ghost,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    const EmptyState(),
                  ],
                ],
              );
            },
          ),
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
          ),
          const SizedBox(height: AppSizes.spacing3),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: '${GlobalConstant.monthMapping[_month]} $_year',
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

  Widget _buildDataList(List<TransactionHistoryEntity> transactionList) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: transactionList.length,
      itemBuilder: (context, index) {
        final item = transactionList[index];
        final previousItem = index > 0 ? transactionList[index - 1] : null;

        bool showHeader =
            previousItem == null ||
            item.transactionDate.day != previousItem.transactionDate.day ||
            item.transactionDate.month != previousItem.transactionDate.month ||
            item.transactionDate.year != previousItem.transactionDate.year;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) ...[
              const SizedBox(height: AppSizes.spacing5),
              DateHeader(date: item.transactionDate),
              const SizedBox(height: AppSizes.spacing3),
            ],
            GestureDetector(
              onTap: () {},
              child: TransactionHistoryItem(transaction: item),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openMonthYearPicker() async {
    // tuple: (month, year)
    final result = await showDialog<(int, int)>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: MonthYearDialogContent(
          initialMonth: _month,
          initialYear: _year,
          startYear: 2024,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _month = result.$1;
        _year = result.$2;
      });
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
    }
  }
}
