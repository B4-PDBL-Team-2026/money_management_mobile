import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_currency_text_field.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';

class ManageFixedCostBottomSheet extends StatefulWidget {
  const ManageFixedCostBottomSheet({
    super.key,
    this.isEditing = false,
    this.initialName,
    this.initialAmount,
    this.initialCategory,
    this.initialCycleType,
    this.initialDueDate,
  });

  final bool isEditing;
  final String? initialName;
  final String? initialAmount;
  final String? initialCategory;
  final String? initialCycleType;
  final String? initialDueDate;

  @override
  State<ManageFixedCostBottomSheet> createState() =>
      _ManageFixedCostBottomSheetState();
}

class _ManageFixedCostBottomSheetState extends State<ManageFixedCostBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _dueDateController;

  late String _selectedCategory;
  late String _selectedCycleType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _amountController = TextEditingController(text: widget.initialAmount ?? '');
    _dueDateController = TextEditingController(text: widget.initialDueDate ?? '');

    _selectedCategory = widget.initialCategory ?? 'Utilitas';
    _selectedCycleType = widget.initialCycleType ?? 'Mingguan';
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
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primary,
                ),
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
                initialValue: _selectedCategory,
                decoration: _dropdownDecoration(context, 'Kategori'),
                items: const [
                  DropdownMenuItem(value: 'Utilitas', child: Text('Utilitas')),
                  DropdownMenuItem(value: 'Transportasi', child: Text('Transportasi')),
                  DropdownMenuItem(value: 'Makanan', child: Text('Makanan')),
                  DropdownMenuItem(value: 'Kesehatan', child: Text('Kesehatan')),
                  DropdownMenuItem(value: 'Entertain', child: Text('Entertain')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
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
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    cancelText: 'Batal',
                    confirmText: 'Pilih',
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dueDateController.text =
                          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                    });
                  }
                },
              ),
              const SizedBox(height: AppSizes.spacing5),
              AppButton(
                text: widget.isEditing ? 'Simpan Perubahan' : 'Simpan',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.pop(context);
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
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.trunks,
      ),
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
