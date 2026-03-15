import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_currency_text_field.dart';
import 'package:money_management_mobile/core/widgets/app_segmented_control.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/category_bottom_sheet.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/category_grid_item.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum TransactionType { expense, income }

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();

  final _expenseIconCategory = {
    'Food': PhosphorIconsRegular.bowlFood,
    'Transport': PhosphorIconsRegular.carSimple,
    'Entertainment': PhosphorIconsRegular.gameController,
    'Shopping': PhosphorIconsRegular.shoppingBag,
    'Health': PhosphorIconsRegular.heart,
    'Education': PhosphorIconsRegular.book,
    'Other': PhosphorIconsRegular.tag,
  };

  final _incomeIconCategory = {
    'Salary': PhosphorIconsRegular.wallet,
    'Gift': PhosphorIconsRegular.gift,
    'Investment': PhosphorIconsRegular.chartLineUp,
    'Other': PhosphorIconsRegular.tag,
  };

  TransactionType _selectedTransactionType = TransactionType.expense;
  String _selectedCategory = 'Other';
  DateTime _selectedDate = DateTime.now();

  Map<String, IconData> get _currentCategoryIcons =>
      switch (_selectedTransactionType) {
        TransactionType.expense => _expenseIconCategory,
        TransactionType.income => _incomeIconCategory,
      };

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(_selectedDate);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(_selectedDate.year - 3),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.gohan,
              onSurface: AppColors.bulma,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _showCategoryBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusNm),
        ),
      ),
      builder: (_) => CategoryBottomSheet(
        categories: _currentCategoryIcons,
        selectedCategory: _selectedCategory,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedCategory = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Tambah Transaksi',
          style: TextStyle(color: AppColors.bulma),
        ),
        elevation: 0,
        titleSpacing: AppSizes.spacing6,
        leading: Transform.translate(
          offset: Offset(AppSizes.spacing4, 0),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacing2),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.gohan,
                  size: AppSizes.spacing5,
                ),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRouter.dashboard);
                  }
                },
              ),
            ),
          ),
        ),
      ),
      body: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            context.go(AppRouter.dashboard);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spacing6),
            child: Column(
              children: [
                AppSegmentedControl<TransactionType>(
                  segments: const [
                    SegmentedControlItem(
                      value: TransactionType.expense,
                      label: 'Pengeluaran',
                      selectedBackgroundColor: AppColors.danger100,
                      selectedTextColor: AppColors.gohan,
                      unselectedIcon: PhosphorIcon(
                        PhosphorIconsRegular.arrowCircleUp,
                      ),
                      selectedIcon: PhosphorIcon(
                        PhosphorIconsFill.arrowCircleUp,
                        color: AppColors.gohan,
                      ),
                    ),
                    SegmentedControlItem(
                      value: TransactionType.income,
                      label: 'Pemasukan',
                      selectedBackgroundColor: AppColors.success100,
                      selectedTextColor: AppColors.gohan,
                      unselectedIcon: PhosphorIcon(
                        PhosphorIconsRegular.arrowCircleDown,
                      ),
                      selectedIcon: PhosphorIcon(
                        PhosphorIconsFill.arrowCircleDown,
                        color: AppColors.gohan,
                      ),
                    ),
                  ],
                  selectedValue: _selectedTransactionType,
                  onChanged: (value) {
                    setState(() {
                      _selectedTransactionType = value;
                      _selectedCategory = 'Other';
                    });
                  },
                ),
                const SizedBox(height: AppSizes.spacing4),
                AppCurrencyTextField(
                  label: 'Nominal',
                  hint: 'Masukkan jumlah transaksi',
                  controller: _amountController,
                ),
                const SizedBox(height: AppSizes.spacing4),
                AppTextField(
                  label: 'Judul/Nama Transaksi',
                  hint: 'Contoh: Geprek Cibus',
                  controller: _titleController,
                ),
                const SizedBox(height: AppSizes.spacing4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kategori',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 14,
                        color: AppColors.trunks,
                      ),
                    ),

                    GestureDetector(
                      onTap: () => _showCategoryBottomSheet(context),
                      child: Text(
                        'Lihat semua',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacing4),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _currentCategoryIcons.length.clamp(0, 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: AppSizes.spacing4,
                    mainAxisSpacing: AppSizes.spacing4,
                    mainAxisExtent: 80,
                  ),
                  itemBuilder: (context, index) {
                    final item = _currentCategoryIcons.entries.elementAt(index);

                    return CategoryGridItem(
                      categoryName: item.key,
                      categoryIcon: item.value,
                      isSelected: _selectedCategory == item.key,
                      onTap: () {
                        if (_selectedCategory != item.key) {
                          setState(() {
                            _selectedCategory = item.key;
                          });
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: AppSizes.spacing4),
                AppTextField(
                  label: 'Pilih Tanggal',
                  hint: 'Pilih tanggal transaksi',
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _pickDate(context),
                  prefixIcon: const PhosphorIcon(
                    PhosphorIconsRegular.calendarBlank,
                  ),
                ),
                const SizedBox(height: AppSizes.spacing4),
                AppTextField(
                  label: 'Catatan (opsional)',
                  hint: 'Tambah catatan untuk transaksi ini',
                  controller: _noteController,
                  maxLines: null,
                ),
                const SizedBox(height: AppSizes.spacing8),
                AppButton(onPressed: () {}, text: 'Simpan'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
