import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_currency_text_field.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart'
    as category;
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

class ManageFixedCostBottomSheet extends StatefulWidget {
  const ManageFixedCostBottomSheet({
    super.key,
    required this.categories,
    this.isEditing = false,
    this.initialName,
    this.initialAmount,
    this.initialCategoryId,
    this.initialCycleType,
    this.initialDueDate,
  });

  final List<CategoryEntity> categories;

  final bool isEditing;
  final String? initialName;
  final String? initialAmount;
  final int? initialCategoryId;
  final String? initialCycleType;
  final String? initialDueDate;

  @override
  State<ManageFixedCostBottomSheet> createState() =>
      _ManageFixedCostBottomSheetState();
}

class _ManageFixedCostBottomSheetState
    extends State<ManageFixedCostBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _dueDateController;

  late int _selectedCategoryId;
  late String _selectedCycleType;
  DateTime? _selectedDueDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _amountController = TextEditingController(text: widget.initialAmount ?? '');
    _dueDateController = TextEditingController(
      text: widget.initialDueDate ?? '',
    );

    final defaultCategoryId = widget.categories.isNotEmpty
        ? widget.categories.first.id
        : 0;
    _selectedCategoryId = widget.initialCategoryId ?? defaultCategoryId;
    _selectedCycleType = widget.initialCycleType ?? 'Mingguan';

    if ((widget.initialDueDate ?? '').isNotEmpty) {
      final dateParts = widget.initialDueDate!.split('/');
      if (dateParts.length == 3) {
        _selectedDueDate = DateTime.tryParse(
          '${dateParts[2]}-${dateParts[1].padLeft(2, '0')}-${dateParts[0].padLeft(2, '0')}',
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.gohan,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.spacing6),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacing6),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.beerus,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacing4),
              Text(
                widget.isEditing ? 'Edit Fixed Cost' : 'Tambah Fixed Cost',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppSizes.spacing4),
              AppTextField(
                hint: 'Nama biaya (contoh: WiFi)',
                controller: _nameController,
                prefixIcon: const Icon(
                  Icons.receipt_outlined,
                  color: AppColors.trunks,
                ),
                validator: (value) {
                  final trimmedName = value?.trim() ?? '';
                  if (trimmedName.isEmpty) {
                    return 'Nama biaya wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spacing4),
              AppCurrencyTextField(
                controller: _amountController,
                hint: 'Nominal',
                prefixIcon: const Icon(
                  Icons.attach_money,
                  color: AppColors.trunks,
                ),
                validator: (value) {
                  if ((value ?? '').isEmpty) {
                    return 'Nominal wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spacing4),
              DropdownButtonFormField<String>(
                initialValue: _selectedCycleType,
                decoration: _dropdownDecoration(context, 'Frekuensi'),
                items: const [
                  DropdownMenuItem(value: 'Mingguan', child: Text('Mingguan')),
                  DropdownMenuItem(value: 'Bulanan', child: Text('Bulanan')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCycleType = value);
                  }
                },
              ),
              const SizedBox(height: AppSizes.spacing4),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId == 0 ? null : _selectedCategoryId,
                decoration: _dropdownDecoration(context, 'Kategori'),
                items: widget.categories
                    .map(
                      (categoryItem) => DropdownMenuItem<int>(
                        value: categoryItem.id,
                        child: Text(categoryItem.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategoryId = value);
                  }
                },
                validator: (value) {
                  if (value == null || value == 0) {
                    return 'Kategori wajib dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spacing4),
              AppTextField(
                hint: 'Pilih tanggal jatuh tempo',
                controller: _dueDateController,
                readOnly: true,
                prefixIcon: const Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.trunks,
                ),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    cancelText: 'Batal',
                    confirmText: 'Pilih',
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDueDate = pickedDate;
                      _dueDateController.text =
                          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                    });
                  }
                },
                validator: (value) {
                  if ((value ?? '').trim().isEmpty ||
                      _selectedDueDate == null) {
                    return 'Tanggal jatuh tempo wajib dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spacing5),
              AppButton(
                text: widget.isEditing ? 'Simpan Perubahan' : 'Simpan',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final selectedCategory = widget.categories.firstWhere(
                      (categoryItem) => categoryItem.id == _selectedCategoryId,
                      orElse: () => widget.categories.first,
                    );

                    final dueDate = _selectedDueDate ?? DateTime.now();
                    final cycle = _selectedCycleType == 'Mingguan'
                        ? FinancialCycle.weekly
                        : FinancialCycle.monthly;
                    final dueDay = cycle == FinancialCycle.weekly
                        ? dueDate.weekday
                        : dueDate.day;

                    final payload = FixedCostEntity(
                      name: _nameController.text.trim(),
                      amount: CurrencyFormatter.parse(_amountController.text),
                      category: selectedCategory.name,
                      categoryId: selectedCategory.id,
                      categoryType:
                          selectedCategory.categoryType ==
                              category.RealCategoryType.system
                          ? CategoryType.system
                          : CategoryType.custom,
                      cycle: cycle,
                      dueValue: dueDay,
                      isActive: true,
                    );

                    Navigator.pop(context, payload);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration(BuildContext context, String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
      filled: true,
      fillColor: AppColors.gohan,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.beerus, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.bulma, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing4,
        vertical: AppSizes.spacing4,
      ),
    );
  }
}
