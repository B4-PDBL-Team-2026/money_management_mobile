import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/category_grid_item.dart';

class CategoryBottomSheet extends StatefulWidget {
  const CategoryBottomSheet({
    super.key,
    required this.categories,
    required this.selectedCategory,
  });

  final Map<String, IconData> categories;
  final String selectedCategory;

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = widget.categories.entries
        .where((e) => e.key.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final availableHeight =
        MediaQuery.sizeOf(context).height * 0.85 - keyboardHeight;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spacing6,
        AppSizes.spacing3,
        AppSizes.spacing6,
        keyboardHeight + AppSizes.spacing6,
      ),
      child: SizedBox(
        height: availableHeight.clamp(0.0, double.infinity),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(
              'Pilih Kategori',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSizes.spacing4),
            AppTextField(
              hint: 'Cari kategori',
              controller: _searchController,
              prefixIcon: const Icon(Icons.search, color: AppColors.trunks),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: AppSizes.spacing4),
            Flexible(
              child: filteredCategories.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.spacing6,
                        ),
                        child: Text(
                          'Kategori tidak ditemukan',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.trunks),
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      itemCount: filteredCategories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: AppSizes.spacing4,
                            mainAxisSpacing: AppSizes.spacing4,
                            mainAxisExtent: 80,
                          ),
                      itemBuilder: (context, index) {
                        final entry = filteredCategories[index];
                        final isSelected = widget.selectedCategory == entry.key;

                        return CategoryGridItem(
                          categoryName: entry.key,
                          categoryIcon: entry.value,
                          isSelected: isSelected,
                          onTap: () => Navigator.of(context).pop(entry.key),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
