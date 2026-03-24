import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_currency_text_field.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_entity.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/utils/profile_utils.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/category.dart';

class AddFixedCostBottomSheet extends StatefulWidget {
  const AddFixedCostBottomSheet({
    super.key,
    required this.draftCubit,
    required this.isMainCycleWeekly,
    required this.expenseCategories,
    this.editingIndex,
    this.initialItem,
  });

  final FinancialProfileDraftCubit draftCubit;
  final bool isMainCycleWeekly;
  final List<Category> expenseCategories;
  final int? editingIndex;
  final FixedCostEntity? initialItem;

  bool get isEditing => editingIndex != null && initialItem != null;

  @override
  State<AddFixedCostBottomSheet> createState() =>
      _AddFixedCostBottomSheetState();
}

class _AddFixedCostBottomSheetState extends State<AddFixedCostBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  late FinancialCycle _frequency;
  late Category _category;
  late List<MapEntry<int, String>> _dueOptions;
  late int _selectedDueValue;

  @override
  void initState() {
    super.initState();
    final initialItem = widget.initialItem;

    if (initialItem != null) {
      _nameController.text = initialItem.name;
      _amountController.text = CurrencyFormatter.format(initialItem.amount);
      _frequency = initialItem.cycle;
      _category = widget.expenseCategories.firstWhere(
        (item) => item.id == initialItem.categoryId,
        orElse: () => widget.expenseCategories.first,
      );
      _dueOptions = _buildDueOptions(_frequency);

      final validDueValue =
          _dueOptions.any((option) => option.key == initialItem.dueValue)
          ? initialItem.dueValue
          : _dueOptions.first.key;
      _selectedDueValue = validDueValue;

      if (_frequency == FinancialCycle.monthly) {
        _dueDateController.text = _monthlyDueText(_selectedDueValue);
      }

      return;
    }

    _frequency = widget.isMainCycleWeekly
        ? FinancialCycle.weekly
        : FinancialCycle.monthly;
    _category = widget.expenseCategories.first;
    _dueOptions = _buildDueOptions(_frequency);
    _selectedDueValue = _dueOptions.first.key;

    if (!widget.isMainCycleWeekly) {
      _selectedDueValue = DateTime.now().day;
      _dueDateController.text = _monthlyDueText(_selectedDueValue);
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
                  final amount = CurrencyFormatter.parse(value ?? '');

                  if (amount <= 0) {
                    return 'Nominal harus lebih besar dari 0';
                  }

                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spacing4),
              DropdownButtonFormField<Category>(
                initialValue: _category,
                decoration: _dropdownDecoration(context, 'Kategori'),
                items: widget.expenseCategories
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item.name)),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _category = value);
                },
              ),
              if (!widget.isMainCycleWeekly) ...[
                const SizedBox(height: AppSizes.spacing4),
                DropdownButtonFormField<FinancialCycle>(
                  initialValue: _frequency,
                  decoration: _dropdownDecoration(context, 'Frekuensi Cost'),
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
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _frequency = value;
                      _dueOptions = _buildDueOptions(_frequency);
                      _selectedDueValue = _dueOptions.first.key;

                      if (_frequency == FinancialCycle.monthly) {
                        _selectedDueValue = DateTime.now().day;
                        _dueDateController.text = _monthlyDueText(
                          _selectedDueValue,
                        );
                      }
                    });
                  },
                ),
              ],
              const SizedBox(height: AppSizes.spacing4),
              if (_frequency == FinancialCycle.weekly)
                DropdownButtonFormField<int>(
                  initialValue: _selectedDueValue,
                  decoration: _dropdownDecoration(
                    context,
                    'Jatuh Tempo (Hari)',
                  ),
                  items: _dueOptions
                      .map(
                        (item) => DropdownMenuItem(
                          value: item.key,
                          child: Text(item.value),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() => _selectedDueValue = value);
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
                    final name = _nameController.text.trim();
                    final amount = CurrencyFormatter.parse(
                      _amountController.text,
                    );

                    final editingIndex = widget.editingIndex;

                    if (widget.isEditing && editingIndex != null) {
                      widget.draftCubit.updateFixedCostAt(
                        index: editingIndex,
                        name: name,
                        amount: amount,
                        category: _category.name,
                        categoryId: _category.id,
                        cycle: _frequency,
                        dueValue: _selectedDueValue,
                      );
                    } else {
                      widget.draftCubit.addFixedCost(
                        name: name,
                        amount: amount,
                        category: _category.name,
                        categoryId: _category.id,
                        cycle: _frequency,
                        dueValue: _selectedDueValue,
                      );
                    }

                    if (!mounted) {
                      return;
                    }

                    context.pop();
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
}
