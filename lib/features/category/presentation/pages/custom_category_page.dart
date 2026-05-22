import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/category/presentation/widgets/custom_category_bottom_sheet.dart';
import 'package:money_management_mobile/features/category/presentation/widgets/custom_category_card.dart';
import 'package:money_management_mobile/features/category/presentation/widgets/custom_category_empty_state.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum DemoState { loaded, loading, empty, error }

class CustomCategoryPage extends StatefulWidget {
  const CustomCategoryPage({super.key});

  @override
  State<CustomCategoryPage> createState() => _CustomCategoryPageState();
}

class _CustomCategoryPageState extends State<CustomCategoryPage> {
  // State controller for demo simulation
  DemoState _currentDemoState = DemoState.loaded;

  // Filter state (null: Semua, expense: Pengeluaran, income: Pemasukan)
  TransactionType? _selectedFilterType;

  // Static list for local simulation in presentation layer (UI Only)
  final List<CategoryEntity> _simulatedCategories = [
    CategoryEntity(
      id: 1,
      name: 'Kopi & Nongkrong',
      icon: 'bowl_food',
      type: TransactionType.expense,
      isSystem: false,
    ),
    CategoryEntity(
      id: 2,
      name: 'Gaji Freelance',
      icon: 'money',
      type: TransactionType.income,
      isSystem: false,
    ),
    CategoryEntity(
      id: 3,
      name: 'Nonton Bioskop',
      icon: 'film_reel',
      type: TransactionType.expense,
      isSystem: false,
    ),
    CategoryEntity(
      id: 4,
      name: 'Belanja Bulanan Supermarket',
      icon: 'shopping_bag',
      type: TransactionType.expense,
      isSystem: false,
    ),
    CategoryEntity(
      id: 5,
      name: 'Hadiah & Sampingan',
      icon: 'gift',
      type: TransactionType.income,
      isSystem: false,
    ),
  ];

  void _showAddBottomSheet() {
    CustomCategoryBottomSheet.show(
      context: context,
      onSave: (name, iconKey, type) {
        final newCategory = CategoryEntity(
          id: DateTime.now().millisecondsSinceEpoch,
          name: name,
          icon: iconKey,
          type: type,
          isSystem: false,
        );
        setState(() {
          _simulatedCategories.insert(0, newCategory);
          _currentDemoState = DemoState.loaded; // Ensure loaded state
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kategori "$name" berhasil ditambahkan (Demo UI)'),
            backgroundColor: AppColors.success100,
          ),
        );
      },
    );
  }

  void _showEditBottomSheet(CategoryEntity category) {
    CustomCategoryBottomSheet.show(
      context: context,
      initialCategory: category,
      onSave: (name, iconKey, type) {
        final index = _simulatedCategories.indexWhere(
          (c) => c.id == category.id,
        );
        if (index != -1) {
          setState(() {
            _simulatedCategories[index] = CategoryEntity(
              id: category.id,
              name: name,
              icon: iconKey,
              type: type,
              isSystem: category.isSystem,
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Perubahan kategori "$name" disimpan (Demo UI)'),
              backgroundColor: AppColors.success100,
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

  void _handleDeleted(CategoryEntity category) {
    final name = category.name;
    setState(() {
      _simulatedCategories.removeWhere((c) => c.id == category.id);
      if (_simulatedCategories.isEmpty) {
        _currentDemoState = DemoState.empty;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kategori "$name" berhasil dihapus (Demo UI)'),
        backgroundColor: AppColors.success100,
      ),
    );
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
        actions: [
          // Simulated state switcher dropdown for easy testing and preview
          PopupMenuButton<DemoState>(
            icon: PhosphorIcon(
              PhosphorIconsRegular.sliders,
              color: AppColors.primary,
            ),
            tooltip: 'Simulasi State Tampilan',
            onSelected: (DemoState state) {
              setState(() {
                _currentDemoState = state;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<DemoState>>[
              const PopupMenuItem<DemoState>(
                value: DemoState.loaded,
                child: Text('Simulasi State: Terisi'),
              ),
              const PopupMenuItem<DemoState>(
                value: DemoState.loading,
                child: Text('Simulasi State: Loading'),
              ),
              const PopupMenuItem<DemoState>(
                value: DemoState.empty,
                child: Text('Simulasi State: Kosong'),
              ),
              const PopupMenuItem<DemoState>(
                value: DemoState.error,
                child: Text('Simulasi State: Error/Gagal'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildBody(),
        ),
      ),
      floatingActionButton: _currentDemoState == DemoState.loaded
          ? FloatingActionButton(
              onPressed: _showAddBottomSheet,
              backgroundColor: AppColors.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppSizes.radiusLg),
                ),
                side: BorderSide(color: AppColors.bulma, width: 1),
              ),
              child: Icon(Icons.add, color: AppColors.bulma),
            )
          : null,
    );
  }

  Widget _buildBody() {
    switch (_currentDemoState) {
      case DemoState.loading:
        return const Center(
          key: ValueKey('loading_state'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.primary,
              ),
              SizedBox(height: AppSizes.spacing4),
              Text(
                'Memuat kategori kustom...',
                style: TextStyle(color: AppColors.trunks),
              ),
            ],
          ),
        );

      case DemoState.empty:
        return CustomCategoryEmptyState(
          key: const ValueKey('empty_state'),
          onAddPressed: _showAddBottomSheet,
        );

      case DemoState.error:
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
                  'Terjadi kesalahan saat mengambil data kategori kustom Anda. Silakan periksa koneksi Anda dan coba lagi.',
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
                      setState(() {
                        _currentDemoState = DemoState.loaded;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );

      case DemoState.loaded:
        if (_simulatedCategories.isEmpty) {
          return CustomCategoryEmptyState(
            key: const ValueKey('empty_loaded_fallback'),
            onAddPressed: _showAddBottomSheet,
          );
        }

        // Filter list locally for demonstration
        final filteredCategories = _simulatedCategories.where((category) {
          if (_selectedFilterType == null) return true;
          return category.type == _selectedFilterType;
        }).toList();

        return Column(
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
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSizes.spacing4),
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
                    )
                  : ListView.builder(
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
        );
    }
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing2, horizontal: AppSizes.spacing3),
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
