import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_mobile/core/constants/global_constant.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_segmented_control.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_cubit.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_state.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CategoryDialogContent extends StatefulWidget {
  final CategoryEntity selectedCategory;
  final CategoryEntity defaultCategory;

  const CategoryDialogContent({
    super.key,
    required this.selectedCategory,
    required this.defaultCategory,
  });

  @override
  State<CategoryDialogContent> createState() => _CategoryDialogContentState();
}

class _CategoryDialogContentState extends State<CategoryDialogContent> {
  final List<CategoryEntity> expenseCategories = [];
  final List<CategoryEntity> incomeCategories = [];

  TransactionType type = TransactionType.expense;
  late CategoryEntity selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory;
    type = selectedCategory.type;

    final categoryState = context.read<CategoryCubit>().state;

    if (categoryState is CategoryLoaded) {
      expenseCategories.addAll(categoryState.expenseCategories);
      incomeCategories.addAll(categoryState.incomeCategories);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeList = type == TransactionType.expense
        ? expenseCategories
        : incomeCategories;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pilih Kategori',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),

              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const PhosphorIcon(PhosphorIconsRegular.x),
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing4),
          AppSegmentedControl(
            segments: [
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
            selectedValue: type,
            onChanged: (val) {
              setState(() {
                type = val;
                selectedCategory = widget.defaultCategory;
              });
            },
          ),
          const SizedBox(height: AppSizes.spacing4),
          Container(
            height: 350,
            color: Colors.transparent,
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: activeList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppSizes.spacing4,
                mainAxisSpacing: AppSizes.spacing4,
                mainAxisExtent: 115,
              ),
              itemBuilder: (context, index) {
                bool isSelected = activeList[index].id == selectedCategory.id;

                Color bgColor = isSelected
                    ? AppColors.primary
                    : AppColors.gohan;
                Color iconColor = isSelected ? Colors.white : AppColors.trunks;

                return GestureDetector(
                  onTap: () => setState(() {
                    if (isSelected) {
                      selectedCategory = widget.defaultCategory;
                    } else {
                      selectedCategory = activeList[index];
                    }
                  }),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                        ),
                        child: PhosphorIcon(
                          GlobalConstant.categoryIconsMapping[activeList[index]
                                  .icon] ??
                              PhosphorIconsRegular.question,
                          color: iconColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacing2),
                      Text(
                        activeList[index].name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.trunks,
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.spacing4),
          AppButton(
            text: 'Konfirmasi Kategori',
            onPressed: () => Navigator.pop(context, selectedCategory),
          ),
        ],
      ),
    );
  }
}
