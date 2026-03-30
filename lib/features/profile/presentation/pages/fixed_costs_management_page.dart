import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_confirm_dialog.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_cubit.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_state.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_occurrence_entity.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/fixed_cost_occurrences_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/fixed_cost_occurrences_state.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/active_fixed_cost_item_card.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/manage_fixed_cost_bottom_sheet.dart';

class FixedCostsManagementPage extends StatefulWidget {
  const FixedCostsManagementPage({super.key});

  @override
  State<FixedCostsManagementPage> createState() =>
      _FixedCostsManagementPageState();
}

class _FixedCostsManagementPageState extends State<FixedCostsManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<FixedCostOccurrencesCubit>().fetchFixedCostOccurrences();
  }

  Future<void> _showAddFixedCostBottomSheet() async {
    final categories = _expenseCategoriesFromState(
      context.read<CategoryCubit>().state,
    );

    if (categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.danger100,
          content: Text(
            'Kategori belum tersedia. Silakan coba lagi.',
            style: TextStyle(color: AppColors.gohan),
          ),
        ),
      );
      return;
    }

    final payload = await showModalBottomSheet<FixedCostEntity>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ManageFixedCostBottomSheet(categories: categories),
    );

    if (!mounted || payload == null) {
      return;
    }

    await context.read<FixedCostOccurrencesCubit>().createFixedCost(payload);
  }

  Future<void> _showEditFixedCostBottomSheet(
    FixedCostOccurrenceEntity fixedCost,
  ) async {
    final payload = await showModalBottomSheet<FixedCostEntity>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ManageFixedCostBottomSheet(
        categories: _expenseCategoriesFromState(
          context.read<CategoryCubit>().state,
        ),
        isEditing: true,
        initialName: fixedCost.name,
        initialAmount: CurrencyFormatter.format(
          _parseAmountFromRaw(fixedCost.amountRaw),
        ),
        initialCategoryId: fixedCost.categoryId,
        initialCycleType: _toCycleLabel(fixedCost.cycleType),
        initialDueDate: DateFormat('dd/MM/yyyy').format(fixedCost.dueDate),
      ),
    );

    if (!mounted || payload == null) {
      return;
    }

    final targetId = fixedCost.fixedCostTemplateId > 0
        ? fixedCost.fixedCostTemplateId
        : fixedCost.id;

    await context.read<FixedCostOccurrencesCubit>().updateFixedCost(
      targetId,
      payload,
    );
  }

  int _parseAmountFromRaw(String rawAmount) {
    final digitsOnly = rawAmount.split('.')[0];
    return int.tryParse(digitsOnly) ?? 0;
  }

  String _toCycleLabel(String cycleType) {
    return switch (cycleType.toLowerCase()) {
      'weekly' => 'Mingguan',
      'monthly' => 'Bulanan',
      _ => cycleType,
    };
  }

  FixedCostStatus _toUiStatus(FixedCostOccurrenceStatus status) {
    return switch (status) {
      FixedCostOccurrenceStatus.paid => FixedCostStatus.paid,
      FixedCostOccurrenceStatus.pending => FixedCostStatus.pending,
      FixedCostOccurrenceStatus.overdue => FixedCostStatus.overdue,
      FixedCostOccurrenceStatus.skipped => FixedCostStatus.skipped,
      FixedCostOccurrenceStatus.voided => FixedCostStatus.void_,
    };
  }

  String _categoryNameById(CategoryState categoryState, int categoryId) {
    if (categoryState is CategoryLoaded) {
      for (final category in categoryState.categories) {
        if (category.id == categoryId) {
          return category.name;
        }
      }
    }

    return 'Kategori #$categoryId';
  }

  List<CategoryEntity> _expenseCategoriesFromState(
    CategoryState categoryState,
  ) {
    if (categoryState is CategoryLoaded) {
      return categoryState.expenseCategories;
    }

    return const [];
  }

  Future<void> _confirmAndDeleteFixedCost(
    FixedCostOccurrenceEntity fixedCost,
  ) async {
    final isConfirmed = await AppConfirmDialog.show(
      context: context,
      title: 'Hapus fixed cost?',
      content:
          'Fixed cost ${fixedCost.name} akan dihapus permanen. Tindakan ini tidak bisa dibatalkan.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      confirmButtonType: AppButtonType.danger,
    );

    if (!isConfirmed || !mounted) {
      return;
    }

    final targetId = fixedCost.fixedCostTemplateId > 0
        ? fixedCost.fixedCostTemplateId
        : fixedCost.id;

    await context.read<FixedCostOccurrencesCubit>().deleteFixedCost(targetId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FixedCostOccurrencesCubit, FixedCostOccurrencesState>(
        builder: (context, state) {
          if (state is FixedCostOccurrencesLoading ||
              state is FixedCostOccurrencesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FixedCostOccurrencesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spacing6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<FixedCostOccurrencesCubit>()
                            .fetchFixedCostOccurrences(forceRefresh: true);
                      },
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final items = (state as FixedCostOccurrencesSuccess).items;
          final categoryState = context.watch<CategoryCubit>().state;

          return RefreshIndicator(
            onRefresh: () {
              return context
                  .read<FixedCostOccurrencesCubit>()
                  .fetchFixedCostOccurrences(forceRefresh: true);
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: BackButton(
                    color: AppColors.gohan,
                    onPressed: () {
                      context.go(AppRouter.other);
                    },
                  ),
                  title: Text('Fixed Cost Management'),
                  pinned: true,
                  elevation: 0,
                ),
                if (items.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.spacing6),
                        child: Text(
                          'Belum ada fixed cost occurrence',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSizes.spacing6),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final fixedCost = items[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSizes.spacing4,
                          ),
                          child: ActiveFixedCostItemCard(
                            name: fixedCost.name,
                            category: _categoryNameById(
                              categoryState,
                              fixedCost.categoryId,
                            ),
                            cycleType: _toCycleLabel(fixedCost.cycleType),
                            dueDate: DateFormat(
                              'dd MMM yyyy',
                              'id_ID',
                            ).format(fixedCost.dueDate),
                            amount:
                                'Rp ${CurrencyFormatter.format(_parseAmountFromRaw(fixedCost.amountRaw))}',
                            status: _toUiStatus(fixedCost.status),
                            showEditAction: true,
                            showDeleteAction: true,
                            onEdit: () =>
                                _showEditFixedCostBottomSheet(fixedCost),
                            onDelete: () =>
                                _confirmAndDeleteFixedCost(fixedCost),
                          ),
                        );
                      }, childCount: items.length),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFixedCostBottomSheet,
        backgroundColor: AppColors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusLg)),
          side: BorderSide(color: AppColors.bulma, width: 1),
        ),
        child: Icon(Icons.add, color: AppColors.bulma),
      ),
    );
  }
}
