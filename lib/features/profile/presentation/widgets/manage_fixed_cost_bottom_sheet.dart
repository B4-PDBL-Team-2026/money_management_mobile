import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart'
    as category;
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/presentation/utils/profile_utils.dart';

class ManageFixedCostBottomSheet extends StatefulWidget {
  const ManageFixedCostBottomSheet({
    super.key,
    required this.categories,
    this.isMainCycleWeekly = false,
    this.isEditing = false,
    this.initialName,
    this.initialAmount,
    this.initialCategoryId,
    this.initialCycleType,
    this.initialDueDate,
  });

  final List<CategoryEntity> categories;
  final bool isMainCycleWeekly;

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
  final TextEditingController _dueDateController = TextEditingController();

  late int _selectedCategoryId;
  late FinancialCycle _frequency;
  late List<MapEntry<int, String>> _dueOptions;
  late int _selectedDueValue;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _amountController = TextEditingController(text: widget.initialAmount ?? '');

    final defaultCategoryId = widget.categories.isNotEmpty
        ? widget.categories.first.id
        : 0;
    _selectedCategoryId = widget.initialCategoryId ?? defaultCategoryId;
    _frequency = widget.isMainCycleWeekly
        ? FinancialCycle.weekly
        : _parseInitialFrequency(widget.initialCycleType);
    _dueOptions = _buildDueOptions(_frequency);
    _selectedDueValue = _dueOptions.first.key;

    final now = DateTime.now();
    if (_frequency == FinancialCycle.monthly) {
      _selectedDueValue = now.day;
      _dueDateController.text = _monthlyDueText(_selectedDueValue);
    }

    if ((widget.initialDueDate ?? '').isNotEmpty) {
      final dateParts = widget.initialDueDate!.split('/');
      if (dateParts.length == 3) {
        final selectedDate = DateTime.tryParse(
          '${dateParts[2]}-${dateParts[1].padLeft(2, '0')}-${dateParts[0].padLeft(2, '0')}',
        );

        if (selectedDate != null) {
          _selectedDueValue = _frequency == FinancialCycle.weekly
              ? selectedDate.weekday
              : selectedDate.day;

          if (_frequency == FinancialCycle.monthly) {
            _dueDateController.text = _monthlyDueText(_selectedDueValue);
          }
        }
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
              if (widget.isMainCycleWeekly) ...[
                const SizedBox(height: AppSizes.spacing4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.spacing3),
                  decoration: BoxDecoration(
                    color: AppColors.gohan,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(color: AppColors.beerus),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: AppColors.trunks,
                      ),
                      const SizedBox(width: AppSizes.spacing2),
                      Expanded(
                        child: Text(
                          'Siklus utama Anda mingguan, jadi fixed cost hanya bisa mingguan dan tidak dapat diubah ke bulanan.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.trunks),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (!widget.isMainCycleWeekly) ...[
                const SizedBox(height: AppSizes.spacing4),
                DropdownButtonFormField<FinancialCycle>(
                  initialValue: _frequency,
                  decoration: _dropdownDecoration(context, 'Frekuensi'),
                  items: const [
                    DropdownMenuItem(
                      value: FinancialCycle.weekly,
                      child: Text('Mingguan'),
                    ),
                    DropdownMenuItem(
                      value: FinancialCycle.monthly,
                      child: Text('Bulanan'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _frequency = value;
                        _dueOptions = _buildDueOptions(_frequency);
                        _selectedDueValue = _dueOptions.first.key;

                        if (_frequency == FinancialCycle.monthly) {
                          _selectedDueValue = DateTime.now().day;
                          _dueDateController.text = _monthlyDueText(
                            _selectedDueValue,
                          );
                        } else {
                          _dueDateController.clear();
                        }
                      });
                    }
                  },
                ),
              ],
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
              if (_frequency == FinancialCycle.weekly)
                DropdownButtonFormField<int>(
                  initialValue: _selectedDueValue,
                  decoration: _dropdownDecoration(context, 'Hari Jatuh Tempo'),
                  items: _dueOptions
                      .map(
                        (item) => DropdownMenuItem<int>(
                          value: item.key,
                          child: Text(item.value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedDueValue = value);
                    }
                  },
                  validator: (value) {
                    if (value == null || value < 1 || value > 7) {
                      return 'Hari jatuh tempo wajib dipilih';
                    }
                    return null;
                  },
                )
              else
                AppTextField(
                  hint: 'Pilih tanggal jatuh tempo (bulan ini)',
                  controller: _dueDateController,
                  readOnly: true,
                  prefixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.trunks,
                  ),
                  onTap: () async {
                    final pickedDate = await _pickDueDateInCurrentMonth(
                      context,
                      _selectedDueValue,
                    );

                    if (!mounted || pickedDate == null) {
                      return;
                    }

                    setState(() {
                      _selectedDueValue = pickedDate.day;
                      _dueDateController.text = _monthlyDueText(
                        _selectedDueValue,
                      );
                    });
                  },
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Tanggal bulan ini wajib dipilih';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: AppSizes.spacing2),
              Row(
                children: [
                  Text(
                    'Jatuh tempo yang lewat akan diabaikan.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
                  ),
                  const SizedBox(width: AppSizes.spacing1),
                  const Tooltip(
                    message:
                        'Jika tanggal sudah terlewat dalam siklus aktif, fixed cost tidak dihitung untuk proyeksi saat ini.',
                    child: Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.trunks,
                    ),
                  ),
                ],
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

                    final cycle = _frequency;
                    final dueDay = _selectedDueValue;

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

  FinancialCycle _parseInitialFrequency(String? rawCycleType) {
    final cycleType = rawCycleType?.toLowerCase();
    if (cycleType == 'bulanan' || cycleType == 'monthly') {
      return FinancialCycle.monthly;
    }

    return FinancialCycle.weekly;
  }

  List<MapEntry<int, String>> _buildDueOptions(FinancialCycle frequency) {
    if (frequency == FinancialCycle.weekly) {
      return ProfileUtils.weekdayOptions;
    }

    return List.generate(
      31,
      (index) => MapEntry(index + 1, 'Tanggal ${index + 1}'),
    );
  }

  Future<DateTime?> _pickDueDateInCurrentMonth(
    BuildContext context,
    int selectedDay,
  ) {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, 1);
    final lastDate = DateTime(now.year, now.month + 1, 0);
    final initialDay = selectedDay.clamp(1, lastDate.day);

    return showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, initialDay),
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Pilih tanggal bulan ini',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );
  }

  String _monthlyDueText(int day) {
    return 'Tanggal $day';
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
