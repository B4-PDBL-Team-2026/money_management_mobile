import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/constants/global_constant.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// The mode that determines how the bottom sheet renders and behaves.
enum BatchItemMode { add, edit }

class BatchTransactionItemBottomSheet extends StatefulWidget {
  const BatchTransactionItemBottomSheet({
    super.key,
    required this.mode,
    required this.expenseCategories,
    required this.incomeCategories,
    required this.initialTransactionDate,
    required this.initialData,
  });

  final TransactionEntity? initialData;
  final BatchItemMode mode;
  final DateTime initialTransactionDate;
  final List<CategoryEntity> expenseCategories;
  final List<CategoryEntity> incomeCategories;

  /// Required when [mode] is [BatchItemMode.edit] or [BatchItemMode.scanned].

  @override
  State<BatchTransactionItemBottomSheet> createState() =>
      _BatchTransactionItemBottomSheetState();
}

class _BatchTransactionItemBottomSheetState
    extends State<BatchTransactionItemBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();

  late TransactionType _selectedType;
  late int _selectedCategoryId;

  @override
  void initState() {
    super.initState();

    final data = widget.initialData;

    if (data != null) {
      _selectedType = data.type;
      _selectedCategoryId = data.categoryId;
      _amountController.text = CurrencyFormatter.format(data.amount);
      _nameController.text = data.name;
    } else {
      _selectedType = TransactionType.expense;
      final firstExpense = widget.expenseCategories.firstOrNull;
      _selectedCategoryId = firstExpense?.id ?? 0;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  List<CategoryEntity> get _activeCategories =>
      _selectedType == TransactionType.expense
      ? widget.expenseCategories
      : widget.incomeCategories;

  void _onTypeChanged(TransactionType type) {
    setState(() {
      _selectedType = type;
      final first = _activeCategories.firstOrNull;
      _selectedCategoryId = first?.id ?? 0;
    });
  }

  void _onConfirm() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final item = TransactionEntity(
      id: widget.initialData?.id ?? IdGenerator.intId(),
      name: _nameController.text.trim(),
      amount: CurrencyFormatter.parse(_amountController.text),
      type: _selectedType,
      categoryId: _selectedCategoryId,
      transactionAt: widget.initialTransactionDate,
      note: _noteController.text.trim(),
    );

    Navigator.of(context).pop(item);
  }

  String get _confirmLabel {
    return switch (widget.mode) {
      BatchItemMode.add => 'Tambah Ke Batch',
      BatchItemMode.edit => 'Simpan Perubahan',
    };
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spacing6,
        AppSizes.spacing3,
        AppSizes.spacing6,
        keyboardHeight + AppSizes.spacing6,
      ),
      decoration: const BoxDecoration(
        color: AppColors.gohan,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusNm),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: AppSizes.spacing10,
                height: AppSizes.spacing1,
                decoration: BoxDecoration(
                  color: AppColors.trunks,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spacing4),

            AppSegmentedControl<TransactionType>(
              segments: const [
                SegmentedControlItem(
                  value: TransactionType.expense,
                  label: 'Pengeluaran',
                  selectedBackgroundColor: AppColors.danger100,
                  selectedTextColor: AppColors.gohan,
                ),
                SegmentedControlItem(
                  value: TransactionType.income,
                  label: 'Pemasukan',
                  selectedBackgroundColor: AppColors.success100,
                  selectedTextColor: AppColors.gohan,
                ),
              ],
              selectedValue: _selectedType,
              onChanged: _onTypeChanged,
            ),
            const SizedBox(height: AppSizes.spacing4),

            AppCurrencyTextField(
              controller: _amountController,
              label: 'Nominal',
              hint: 'Rp. 0',
              max: 1000000000,
              validator: (value) {
                if (value == null) return requiredFieldMessage('Nominal');
                if (value <= 0) return positiveNumberMessage('Nominal');
                if (value > 1000000000) {
                  return maxValueMessage('Nominal', 1000000000);
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.spacing4),

            AppTextField(
              controller: _nameController,
              label: 'Judul / Nama Transaksi',
              hint: 'Gaji Bulan April',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return requiredFieldMessage('Nama transaksi');
                }
                if (value.length > 255) {
                  return maxLengthMessage('Nama transaksi', 255);
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.spacing4),

            // Category dropdown
            Text(
              'Kategori',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 14,
                color: AppColors.trunks,
              ),
            ),
            const SizedBox(height: AppSizes.spacing2),
            DropdownButtonFormField<int>(
              initialValue: _selectedCategoryId == 0
                  ? null
                  : _selectedCategoryId,
              decoration: _dropdownDecoration(context),
              items: _activeCategories
                  .map(
                    (cat) => DropdownMenuItem<int>(
                      value: cat.id,
                      child: Row(
                        children: [
                          PhosphorIcon(
                            GlobalConstant.categoryIconsMapping[cat.icon] ??
                                PhosphorIconsRegular.tag,
                            size: 16,
                            color: AppColors.trunks,
                          ),
                          const SizedBox(width: AppSizes.spacing2),
                          Text(cat.name),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                final cat = _activeCategories.firstWhere((c) => c.id == value);
                setState(() => _selectedCategoryId = cat.id);
              },
              validator: (value) {
                if (value == null || value == 0) {
                  return 'Kategori wajib dipilih';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.spacing6),

            AppButton(text: _confirmLabel, onPressed: _onConfirm),
          ],
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration(BuildContext context) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.trunks),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.trunks),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.bulma, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.danger100),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing4,
        vertical: AppSizes.spacing4,
      ),
    );
  }
}
