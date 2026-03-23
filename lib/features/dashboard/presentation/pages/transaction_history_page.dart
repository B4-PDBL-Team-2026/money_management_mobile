import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/features/transaction/presentation/pages/detail_transaction.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/transaction_components.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistoryPage> {
  String selectedMonthYear = 'Februari 2026';
  String selectedCategory = 'Semua';

  List<dynamic> transactionList = [];
  int totalPengeluaran = 0;
  int totalPemasukan = 0;

  // format rupiah
  String _formatRupiah(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

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
              const SizedBox(height: AppSizes.spacing4),
              _buildFilterSection(),
              const SizedBox(height: AppSizes.spacing4),
              _buildSummarySection(),
              const SizedBox(height: AppSizes.spacing4),
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
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama transaksi...',
                hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF9E9E9E),
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
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
            amount: '- Rp ${_formatRupiah(totalPengeluaran)}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryCard(
            title: 'Total Pemasukan',
            amount: '+ Rp ${_formatRupiah(totalPemasukan)}',
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
