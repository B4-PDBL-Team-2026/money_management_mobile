import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_container_card.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';
import 'package:money_management_mobile/features/transaction/presentation/pages/detail_transaction.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/transaction_components.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistoryPage> {
  final _searchController = TextEditingController();

  String selectedMonthYear = 'Februari 2026';
  String selectedCategory = 'Semua';

  List<dynamic> transactionList = [];
  int totalPengeluaran = 0;
  int totalPemasukan = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 10,
                child: FilterButton(
                  icon: Icons.calendar_today,
                  text: selectedMonthYear,
                  onTap: _openMonthYearPicker,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 8,
                child: FilterButton(
                  icon: Icons.grid_view_rounded,
                  text: selectedCategory,
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
                color: primaryBlue,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionDetailScreen(
                      isExpense: item['isExpense'] ?? true,
                      title: item['title'] ?? '',
                      nominal: 'Rp ${item['amount']}',
                      category: item['category'] ?? '',
                      categoryIcon: item['icon'] ?? Icons.help_outline,
                      date: item['date'] ?? '',
                      note: item['note'] ?? '',
                    ),
                  ),
                );
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
    List<String> currentSelection = selectedMonthYear.split(' ');
    String tempMonth = currentSelection.isNotEmpty
        ? currentSelection[0]
        : 'Februari';
    String tempYear = currentSelection.length > 1
        ? currentSelection[1]
        : '2026';

    final result = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: MonthYearDialogContent(
          initialMonth: tempMonth,
          initialYear: tempYear,
        ),
      ),
    );

    if (result != null) setState(() => selectedMonthYear = result);
  }

  Future<void> _openCategoryPicker() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: CategoryDialogContent(initialCategory: selectedCategory),
      ),
    );
    if (result != null) setState(() => selectedCategory = result);
  }
}
