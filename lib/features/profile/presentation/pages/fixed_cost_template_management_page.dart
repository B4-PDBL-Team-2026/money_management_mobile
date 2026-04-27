import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_cubit.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_state.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_state.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_occurrence_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_template_entity.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/fixed_cost_template_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/fixed_cost_template_state.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/active_fixed_cost_item_card.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/manage_fixed_cost_bottom_sheet.dart';
import 'package:money_management_mobile/injection_container.dart';

class FixedCostTemplateManagementPage extends StatefulWidget {
  const FixedCostTemplateManagementPage({super.key});

  @override
  State<FixedCostTemplateManagementPage> createState() =>
      _FixedCostTemplateManagementPageState();
}

class _FixedCostTemplateManagementPageState
    extends State<FixedCostTemplateManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<FixedCostTemplateCubit>().fetchFixedCostTemplate();
  }

  Future<void> _showAddFixedCostBottomSheet() async {
    final categories = _expenseCategoriesFromState(
      context.read<CategoryCubit>().state,
    );
    final isMainCycleWeekly = await _resolveIsMainCycleWeekly();

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

    final payload = await showModalBottomSheet<FixedCostTemplateEntity>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ManageFixedCostBottomSheet(
        categories: categories,
        isMainCycleWeekly: isMainCycleWeekly,
      ),
    );

    if (!mounted || payload == null) {
      return;
    }

    await context.read<FixedCostTemplateCubit>().createFixedCost(payload);
  }

  Future<void> _showEditFixedCostBottomSheet(
    FixedCostOccurrenceEntity fixedCost,
  ) async {
    final isMainCycleWeekly = await _resolveIsMainCycleWeekly();

    final payload = await showModalBottomSheet<FixedCostTemplateEntity>(
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
        isMainCycleWeekly: isMainCycleWeekly,
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

    await context.read<FixedCostTemplateCubit>().updateFixedCost(
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

  String _weekdayLabel(int weekday) {
    return switch (weekday) {
      DateTime.monday => 'Senin',
      DateTime.tuesday => 'Selasa',
      DateTime.wednesday => 'Rabu',
      DateTime.thursday => 'Kamis',
      DateTime.friday => 'Jumat',
      DateTime.saturday => 'Sabtu',
      DateTime.sunday => 'Minggu',
      _ => 'Senin',
    };
  }

  String _dueLabel(FixedCostOccurrenceEntity fixedCost) {
    if (fixedCost.cycleType.toLowerCase() == 'weekly') {
      return _weekdayLabel(fixedCost.dueDate.weekday);
    }

    return DateFormat('dd MMM yyyy', 'id_ID').format(fixedCost.dueDate);
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

  Future<bool> _resolveIsMainCycleWeekly() async {
    final dashboardMetricCubit = getIt<DashboardMetricCubit>();
    var dashboardState = dashboardMetricCubit.state;

    if (dashboardState is DashboardMetricInitial) {
      await dashboardMetricCubit.fetchDashboardMetrics();
      dashboardState = dashboardMetricCubit.state;
    }

    if (dashboardState is DashboardMetricLoaded) {
      return dashboardState.metrics.budgetCycle == FinancialCycle.weekly;
    }

    return false;
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

    await context.read<FixedCostTemplateCubit>().deleteFixedCost(targetId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FixedCostTemplateCubit, FixedCostTemplateState>(
        builder: (context, state) {
          if (state is FixedCostTemplateLoading ||
              state is FixedCostTemplateInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FixedCostTemplateError) {
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
                            .read<FixedCostTemplateCubit>()
                            .fetchFixedCostTemplate(forceRefresh: true);
                      },
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final items = (state as FixedCostTemplateSuccess).items;
          final categoryState = context.watch<CategoryCubit>().state;

          return RefreshIndicator(
            onRefresh: () {
              return context
                  .read<FixedCostTemplateCubit>()
                  .fetchFixedCostTemplate(forceRefresh: true);
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: BackButton(
                    color: AppColors.gohan,
                    onPressed: () {
                      context.pop();
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
                          'Belum ada fixed cost',
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
                            dueDate: _dueLabel(fixedCost),
                            amount:
                                'Rp ${CurrencyFormatter.format(_parseAmountFromRaw(fixedCost.amountRaw))}',
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
