import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/constants/global_constant.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomCategoryBottomSheet extends StatefulWidget {
  final CategoryEntity? initialCategory;
  final void Function(String name, String iconKey, TransactionType type) onSave;

  const CustomCategoryBottomSheet({
    super.key,
    this.initialCategory,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    CategoryEntity? initialCategory,
    required void Function(String name, String iconKey, TransactionType type)
    onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomCategoryBottomSheet(
        initialCategory: initialCategory,
        onSave: onSave,
      ),
    );
  }

  @override
  State<CustomCategoryBottomSheet> createState() =>
      _CustomCategoryBottomSheetState();
}

class _CustomCategoryBottomSheetState extends State<CustomCategoryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String _selectedIconKey;
  late TransactionType _selectedType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialCategory?.name ?? '',
    );
    _selectedIconKey = widget.initialCategory?.icon ?? 'question';
    _selectedType = widget.initialCategory?.type ?? TransactionType.expense;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _isEditMode => widget.initialCategory != null;

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.gohan,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusXl),
          topRight: Radius.circular(AppSizes.radiusXl),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSizes.spacing6,
        AppSizes.spacing6,
        AppSizes.spacing6,
        AppSizes.spacing6 + keyboardPadding,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pull Bar Indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.beerus,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacing6),

              // Title
              Text(
                _isEditMode ? 'Edit Kategori Kustom' : 'Tambah Kategori Kustom',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.bulma,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacing6),

              // Type Selector (Segmented Control)
              Text(
                'Tipe Kategori',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.trunks,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSizes.spacing2),
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
                selectedValue: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
              ),
              const SizedBox(height: AppSizes.spacing5),

              // Name Field
              AppTextField(
                label: 'Nama Kategori',
                hint: 'Masukkan nama kategori baru...',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama kategori harus diisi';
                  }
                  if (value.trim().length > 30) {
                    return 'Maksimal panjang nama 30 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spacing5),

              // Icon Grid Picker
              Text(
                'Pilih Ikon Kategori',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.trunks,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSizes.spacing3),
              Container(
                height: 180,
                padding: const EdgeInsets.all(AppSizes.spacing3),
                decoration: BoxDecoration(
                  color: AppColors.gohan,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: AppColors.beerus),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: AppSizes.spacing3,
                    mainAxisSpacing: AppSizes.spacing3,
                  ),
                  itemCount: GlobalConstant.categoryIconsMapping.length,
                  itemBuilder: (context, index) {
                    final entry = GlobalConstant.categoryIconsMapping.entries
                        .elementAt(index);
                    final iconKey = entry.key;
                    final iconData = entry.value;
                    final isSelected = iconKey == _selectedIconKey;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIconKey = iconKey;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSm,
                          ),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.beerus,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: PhosphorIcon(
                            iconData,
                            color: isSelected
                                ? AppColors.gohan
                                : isDark
                                ? AppColors.gohan
                                : AppColors.bulma,
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.spacing6),

              // Submit Button
              AppButton(
                text: _isEditMode ? 'Simpan Perubahan' : 'Tambah Kategori',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onSave(
                      _nameController.text.trim(),
                      _selectedIconKey,
                      _selectedType,
                    );
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
