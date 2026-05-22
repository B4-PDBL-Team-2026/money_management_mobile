import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/custom_category_cubit.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/custom_category_state.dart';
import 'package:money_management_mobile/features/category/presentation/widgets/custom_category_bottom_sheet.dart';
import 'package:money_management_mobile/features/category/presentation/widgets/custom_category_card.dart';
import 'package:money_management_mobile/features/category/presentation/widgets/custom_category_empty_state.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomCategoryPage extends StatefulWidget {
  const CustomCategoryPage({super.key});

  @override
  State<CustomCategoryPage> createState() => _CustomCategoryPageState();
}

class _CustomCategoryPageState extends State<CustomCategoryPage> {
  // Filter state (null: Semua, expense: Pengeluaran, income: Pemasukan)
  TransactionType? _selectedFilterType;

  @override
  void initState() {
    super.initState();
    // Fetch custom categories on initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomCategoryCubit>().fetchCustomCategories();
    });
  }

  void _showAddBottomSheet() {
    CustomCategoryBottomSheet.show(
      context: context,
      onSave: (name, iconKey, type) async {
        final success = await context
            .read<CustomCategoryCubit>()
            .addCustomCategory(name: name, icon: iconKey, type: type);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? 'Kategori "$name" berhasil ditambahkan!'
                    : 'Gagal menambahkan kategori kustom.',
              ),
              backgroundColor: success
                  ? AppColors.success100
                  : AppColors.danger100,
            ),
          );
        }
      },
    );
  }

  void _showEditBottomSheet(CategoryEntity category) {
    CustomCategoryBottomSheet.show(
      context: context,
      initialCategory: category,
      onSave: (name, iconKey, type) async {
        final success = await context
            .read<CustomCategoryCubit>()
            .updateCustomCategory(
              categoryId: category.id,
              name: name,
              icon: iconKey,
              type: type,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? 'Perubahan kategori "$name" berhasil disimpan!'
                    : 'Gagal memperbarui kategori kustom.',
              ),
              backgroundColor: success
                  ? AppColors.success100
                  : AppColors.danger100,
            ),
          );
        }
      },
    );
  }

  Future<bool> _confirmDelete(CategoryEntity category) async {
    final confirmed = await AppConfirmDialog.show(
      context: context,
      title: 'Hapus Kategori?',
      content:
          'Apakah Anda yakin ingin menghapus kategori "${category.name}"? Transaksi dengan kategori ini akan dialihkan ke kategori default.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      confirmButtonType: AppButtonType.danger,
    );
    return confirmed;
  }

  void _handleDeleted(CategoryEntity category) async {
    final name = category.name;
    final success = await context
        .read<CustomCategoryCubit>()
        .deleteCustomCategory(category.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Kategori "$name" berhasil dihapus!'
                : 'Gagal menghapus kategori kustom.',
          ),
          backgroundColor: success ? AppColors.success100 : AppColors.danger100,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gohan,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: AppSizes.spacing6,
        leadingWidth: 72,
        title: const Text(
          'Kategori Kustom',
          style: TextStyle(color: AppColors.bulma),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(
            left: AppSizes.spacing6,
            top: AppSizes.spacing2,
            bottom: AppSizes.spacing2,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back, color: AppColors.gohan),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<CustomCategoryCubit, CustomCategoryState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildBody(state),
            );
          },
        ),
      ),
      floatingActionButton:
          BlocBuilder<CustomCategoryCubit, CustomCategoryState>(
            builder: (context, state) {
              if (state is CustomCategoryLoaded) {
                return FloatingActionButton(
                  onPressed: _showAddBottomSheet,
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(AppSizes.radiusLg),
                    ),
                    side: const BorderSide(color: AppColors.bulma, width: 1),
                  ),
                  child: const Icon(Icons.add, color: AppColors.bulma),
                );
              }
              return const SizedBox.shrink();
            },
          ),
    );
  }

  Widget _buildBody(CustomCategoryState state) {
    if (state is CustomCategoryLoading) {
      return const Center(
        key: ValueKey('loading_state'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
            SizedBox(height: AppSizes.spacing4),
            Text(
              'Memuat kategori kustom...',
              style: TextStyle(color: AppColors.trunks),
            ),
          ],
        ),
      );
    }

    if (state is CustomCategoryEmptyState) {
      return CustomCategoryEmptyState(
        key: const ValueKey('empty_state'),
        onAddPressed: _showAddBottomSheet,
      );
    }

    if (state is CustomCategoryError) {
      return Center(
        key: const ValueKey('error_state'),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.spacing5),
                decoration: BoxDecoration(
                  color: AppColors.danger10.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: PhosphorIcon(
                  PhosphorIconsRegular.warningOctagon,
                  size: 56,
                  color: AppColors.danger100,
                ),
              ),
              const SizedBox(height: AppSizes.spacing4),
              Text(
                'Gagal Memuat Kategori',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.bulma,
                ),
              ),
              const SizedBox(height: AppSizes.spacing2),
              Text(
                state.message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacing6),
              SizedBox(
                width: 150,
                child: AppButton(
                  text: 'Coba Lagi',
                  onPressed: () {
                    context.read<CustomCategoryCubit>().fetchCustomCategories();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is CustomCategoryErrorAndRetry) {
      return Center(
        key: const ValueKey('error_retry_state'),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.spacing5),
                decoration: BoxDecoration(
                  color: AppColors.danger10.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: PhosphorIcon(
                  PhosphorIconsRegular.warningOctagon,
                  size: 56,
                  color: AppColors.danger100,
                ),
              ),
              const SizedBox(height: AppSizes.spacing4),
              Text(
                'Koneksi Bermasalah',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.bulma,
                ),
              ),
              const SizedBox(height: AppSizes.spacing2),
              Text(
                state.message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacing6),
              SizedBox(
                width: 150,
                child: AppButton(text: 'Coba Lagi', onPressed: state.onRetry),
              ),
            ],
          ),
        ),
      );
    }

    if (state is CustomCategoryLoaded) {
      final categories = state.categories;

      if (categories.isEmpty) {
        return CustomCategoryEmptyState(
          key: const ValueKey('empty_loaded_fallback'),
          onAddPressed: _showAddBottomSheet,
        );
      }

      // Filter list locally for presentation
      final filteredCategories = categories.where((category) {
        if (_selectedFilterType == null) return true;
        return category.type == _selectedFilterType;
      }).toList();

      return RefreshIndicator(
        onRefresh: () async {
          await context.read<CustomCategoryCubit>().fetchCustomCategories();
        },
        color: AppColors.primary,
        child: Column(
          key: const ValueKey('loaded_state'),
          children: [
            // Filter Chip Section
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spacing6,
                AppSizes.spacing3,
                AppSizes.spacing6,
                AppSizes.spacing3,
              ),
              child: Row(
                children: [
                  _buildFilterChip(
                    label: 'Semua',
                    isSelected: _selectedFilterType == null,
                    onTap: () {
                      setState(() {
                        _selectedFilterType = null;
                      });
                    },
                  ),
                  const SizedBox(width: AppSizes.spacing2),
                  _buildFilterChip(
                    label: 'Pengeluaran',
                    isSelected: _selectedFilterType == TransactionType.expense,
                    onTap: () {
                      setState(() {
                        _selectedFilterType = TransactionType.expense;
                      });
                    },
                  ),
                  const SizedBox(width: AppSizes.spacing2),
                  _buildFilterChip(
                    label: 'Pendapatan',
                    isSelected: _selectedFilterType == TransactionType.income,
                    onTap: () {
                      setState(() {
                        _selectedFilterType = TransactionType.income;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Category List Section
            Expanded(
              child: filteredCategories.isEmpty
                  ? ListView(
                      // Wrap in ListView with AlwaysScrollableScrollPhysics to support RefreshIndicator even when empty
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(
                                  AppSizes.spacing4,
                                ),
                                decoration: const BoxDecoration(
                                  color: AppColors.lightPrimary,
                                  shape: BoxShape.circle,
                                ),
                                child: PhosphorIcon(
                                  PhosphorIconsRegular.tag,
                                  size: 32,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: AppSizes.spacing3),
                              Text(
                                'Kategori Tidak Ditemukan',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.bulma,
                                    ),
                              ),
                              const SizedBox(height: AppSizes.spacing1),
                              const Text(
                                'Belum ada kategori kustom untuk tipe ini.',
                                style: TextStyle(color: AppColors.trunks),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spacing6,
                        vertical: AppSizes.spacing2,
                      ),
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        final category = filteredCategories[index];
                        return CustomCategoryCard(
                          category: category,
                          onTap: () => _showEditBottomSheet(category),
                          confirmDismiss: (direction) =>
                              _confirmDelete(category),
                          onDismissed: (direction) => _handleDeleted(category),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.spacing2,
          horizontal: AppSizes.spacing3,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius2xl),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.beerus,
            width: 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.bulma,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
