import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/constants/global_constant.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_container_card.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/category_dialog_content.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/month_year_dialog_content.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/summary_card.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/transaction_components.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TransactionHistoryPage extends StatefulWidget {
  TransactionHistoryPage({super.key});

  final _defaultCategories = CategoryEntity(
    id: 0,
    name: 'Semua',
    icon: 'default',
    type: TransactionType.expense,
  );

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistoryPage> {
  final _searchController = TextEditingController();

  late int _month;
  late int _year;
  late CategoryEntity _selectedCategory;

  List<dynamic> transactionList = [];
  int totalPengeluaran = 0;
  int totalPemasukan = 0;

  @override
  void initState() {
    super.initState();

    _selectedCategory = widget._defaultCategories;

    final now = DateTime.now();
    _month = now.month;
    _year = now.year;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Riwayat Transaksi',
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppSizes.spacing6),
              _buildFilterSection(),
              const SizedBox(height: AppSizes.spacing3),
              _buildSummarySection(),
              const SizedBox(height: AppSizes.spacing3),
              Expanded(
                child: transactionList.isNotEmpty
                    ? _buildDataList()
                    : const EmptyState(),
              ),
            ],
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
                child: FilterButton(
                  icon: PhosphorIconsRegular.calendarBlank,
                  text: '${GlobalConstant.monthMapping[_month]} $_year',
                  onTap: _openMonthYearPicker,
                ),
              ),
              const SizedBox(width: AppSizes.spacing3),
              Expanded(
                child: FilterButton(
                  icon:
                      GlobalConstant.categoryIconsMapping[_selectedCategory
                          .icon] ??
                      PhosphorIconsRegular.squaresFour,
                  text: _selectedCategory.name,
                  onTap: _openCategoryPicker,
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

  Widget _buildDataList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: transactionList.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              '${transactionList.length} Transaksi',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          );
        }

        if (index == transactionList.length + 1) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  // integrasi api load more
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB74D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Muat Lebih Banyak',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }

        final item = transactionList[index - 1];
        final previousItem = index > 1 ? transactionList[index - 2] : null;

        // logika pemisah header tanggal
        bool showHeader =
            previousItem == null || previousItem['date'] != item['date'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) DateHeader(date: item['date']),
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => TransactionDetailScreen(
                //       isExpense: item['isExpense'] ?? true,
                //       title: item['title'] ?? '',
                //       nominal: 'Rp ${item['amount']}',
                //       category: item['category'] ?? '',
                //       categoryIcon: item['icon'] ?? Icons.help_outline,
                //       date: item['date'] ?? '',
                //       note: item['note'] ?? '',
                //     ),
                //   ),
                // );
              },
              child: TransactionItem(
                title: item['title'] ?? '',
                category: item['category'] ?? '',
                amount: '${item['isExpense'] ? '-' : '+'} Rp ${item['amount']}',
                icon: item['icon'] ?? Icons.help_outline,
                isExpense: item['isExpense'] ?? true,
              ),
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
          defaultCategory: widget._defaultCategories,
          selectedCategory: _selectedCategory,
        ),
      ),
    );

    if (result != null) {
      setState(() => _selectedCategory = result);
    }
  }
}
