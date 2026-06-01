import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_cubit.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_state.dart';
import 'package:money_management_mobile/features/dashboard/domain/usecases/calculate_dashboard_metrics_usecase.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_state.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_detail_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_detail_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_detail_state.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/category_bottom_sheet.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/category_grid_item.dart';
import 'package:picons/picons.dart';

class EditTransactionPage extends StatefulWidget {
  final int transactionId;
  final TransactionDetailEntity transactionDetail;

  const EditTransactionPage({
    super.key,
    required this.transactionId,
    required this.transactionDetail,
  });

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _amountController;
  late final TextEditingController _nameController;
  late final TextEditingController _dateController;
  late final TextEditingController _noteController;

  final List<CategoryEntity> _expenseCategories = [];
  final List<CategoryEntity> _incomeCategories = [];

  late TransactionType _selectedTransactionType;
  late int _selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    final detail = widget.transactionDetail;
    _selectedTransactionType = detail.type ?? TransactionType.expense;
    _selectedDate = detail.transactionAt;
    _selectedCategory = detail.categoryId;

    _amountController = TextEditingController(
      text: CurrencyFormatter.format(detail.amount),
    );
    _nameController = TextEditingController(text: detail.name);
    _dateController = TextEditingController(text: _formatDate(_selectedDate));
    _noteController = TextEditingController(text: detail.note ?? '');

    final state = context.read<CategoryCubit>().state;
    if (state is CategoryLoaded) {
      _expenseCategories.addAll(state.expenseCategories);
      _incomeCategories.addAll(state.incomeCategories);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  Future<void> _showCategoryBottomSheet() async {
    final currentCategories =
        _selectedTransactionType == TransactionType.expense
            ? _expenseCategories
            : _incomeCategories;

    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusNm),
        ),
      ),
      builder: (_) => CategoryBottomSheet(
        categories: currentCategories,
        selectedCategory: _selectedCategory,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedCategory = result;
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(_selectedDate.year - 3),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.gohan,
              onSurface: AppColors.bulma,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpenseSelected =
        _selectedTransactionType == TransactionType.expense;
    final currentCategories =
        isExpenseSelected ? _expenseCategories : _incomeCategories;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Update Transaksi',
          style: TextStyle(color: AppColors.bulma),
        ),
        elevation: 0,
        titleSpacing: AppSizes.spacing6,
        leading: Transform.translate(
          offset: Offset(AppSizes.spacing4, 0),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacing2),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.gohan,
                  size: AppSizes.spacing5,
                ),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRouter.dashboard);
                  }
                },
              ),
            ),
          ),
        ),
      ),
      body: PopScope(
        canPop: true,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spacing6),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  AppSegmentedControl<TransactionType>(
                    segments: const [
                      SegmentedControlItem(
                        value: TransactionType.expense,
                        label: 'Pengeluaran',
                        selectedBackgroundColor: AppColors.danger100,
                        selectedTextColor: AppColors.gohan,
                        unselectedIcon: Icon(PiconsRegular.arrowCircleUp),
                        selectedIcon: Icon(
                          PiconsFill.arrowCircleUp,
                          color: AppColors.gohan,
                        ),
                      ),
                      SegmentedControlItem(
                        value: TransactionType.income,
                        label: 'Pemasukan',
                        selectedBackgroundColor: AppColors.success100,
                        selectedTextColor: AppColors.gohan,
                        unselectedIcon: Icon(PiconsRegular.arrowCircleDown),
                        selectedIcon: Icon(
                          PiconsFill.arrowCircleDown,
                          color: AppColors.gohan,
                        ),
                      ),
                    ],
                    selectedValue: _selectedTransactionType,
                    onChanged: (value) {
                      setState(() {
                        _selectedTransactionType = value;
                        _selectedCategory = 0;
                        final nextCategories = value == TransactionType.expense
                            ? _expenseCategories
                            : _incomeCategories;
                        if (nextCategories.isNotEmpty) {
                          _selectedCategory = nextCategories.first.id;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: AppSizes.spacing4),
                  AppCurrencyTextField(
                    label: 'Nominal',
                    hint: 'Masukkan jumlah transaksi',
                    controller: _amountController,
                    max: 1000000000,
                    validator: (value) {
                      if (value == null) {
                        return requiredFieldMessage('Nominal');
                      }

                      if (value <= 0) {
                        return moreThanFieldMessage('Nominal', '0');
                      }

                      if (value > 1000000000) {
                        return maxValueMessage('Nominal', 1000000000);
                      }

                      final dashboardMetricState =
                          context.read<DashboardMetricCubit>().state;

                      if (dashboardMetricState is DashboardMetricLoaded) {
                        if (_selectedTransactionType ==
                                TransactionType.expense &&
                            value > dashboardMetricState.metrics.balance) {
                          return maxValueMessage(
                            'Nominal pengeluaran',
                            dashboardMetricState.metrics.balance,
                          );
                        }
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: AppSizes.spacing4),
                  AppTextField(
                    label: 'Judul/Nama Transaksi',
                    hint: 'Masukkan nama transaksi',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return requiredFieldMessage('Judul transaksi');
                      }

                      if (value.length > 255) {
                        return maxLengthMessage('Judul transaksi', 255);
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: AppSizes.spacing4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kategori',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              fontSize: 14,
                              color: AppColors.trunks,
                            ),
                      ),
                      GestureDetector(
                        onTap: _showCategoryBottomSheet,
                        child: Text(
                          'Lihat semua',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacing4),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: currentCategories.length.clamp(0, 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: AppSizes.spacing4,
                      mainAxisSpacing: AppSizes.spacing4,
                      mainAxisExtent: 80,
                    ),
                    itemBuilder: (context, index) {
                      final category = currentCategories[index];

                      return CategoryGridItem(
                        categoryName: category.name,
                        categoryIcon: category.icon,
                        isSelected: _selectedCategory == category.id,
                        onTap: () {
                          if (_selectedCategory != category.id) {
                            setState(() {
                              _selectedCategory = category.id;
                            });
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: AppSizes.spacing4),
                  AppTextField(
                    label: 'Pilih Tanggal',
                    hint: 'Pilih tanggal transaksi',
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    prefixIcon: const Icon(PiconsRegular.calendarBlank),
                  ),
                  const SizedBox(height: AppSizes.spacing4),
                  AppTextField(
                    label: 'Catatan (opsional)',
                    hint: 'Tambah catatan untuk transaksi ini',
                    controller: _noteController,
                    maxLines: null,
                    validator: (value) {
                      if (value != null) {
                        if (value.length > 1000) {
                          return maxLengthMessage('Catatan', 1000);
                        }
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: AppSizes.spacing8),
                  AppButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      final amount = CurrencyFormatter.parse(
                        _amountController.text,
                      );

                      bool shouldProceed = true;

                      if (_selectedTransactionType == TransactionType.expense) {
                        final dashboardMetricState =
                            context.read<DashboardMetricCubit>().state;

                        if (dashboardMetricState is DashboardMetricLoaded) {
                          final metrics = dashboardMetricState.metrics;

                          final oldAmount = widget.transactionDetail.amount;
                          final adjustedTodaySpent =
                              metrics.todaySpent - oldAmount;
                          final willBeOverBudget =
                              adjustedTodaySpent + amount > metrics.limit;
                          final isAlreadyOverBudget =
                              metrics.limitState ==
                                  DashboardLimitState.overLastLimit;

                          if (isAlreadyOverBudget || willBeOverBudget) {
                            shouldProceed = await AppConfirmDialog.show(
                              context: context,
                              title: 'Pengeluaran Berlebihan!',
                              content:
                                  'Yakin ingin mengubah transaksi pengeluaran ini? pengeluaran kamu sudah melebihi batas normal!',
                              confirmText: 'Yakin',
                              cancelText: 'Batal',
                              confirmButtonType: AppButtonType.danger,
                            );
                          }
                        }
                      }

                      if (!shouldProceed || !context.mounted) return;

                      try {
                        final success = await context
                            .read<TransactionDetailCubit>()
                            .updateTransaction(
                              id: widget.transactionId,
                              amount: amount,
                              name: _nameController.text.trim(),
                              categoryId: _selectedCategory,
                              transactionAt: _selectedDate,
                              note: _noteController.text.trim().isEmpty
                                  ? null
                                  : _noteController.text.trim(),
                              type: _selectedTransactionType,
                            );

                        if (success && context.mounted) {
                          AppSnackBar.showSuccess(
                            context,
                            'Transaksi berhasil diperbarui.',
                          );
                          context.pop(true);
                        } else if (!success && context.mounted) {
                          final state =
                              context.read<TransactionDetailCubit>().state;
                          final message = state is TransactionDetailError
                              ? state.message
                              : 'Gagal memperbarui transaksi. Coba lagi.';
                          AppSnackBar.showError(context, message);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          AppSnackBar.showError(
                            context,
                            'Terjadi kesalahan: ${e.toString()}',
                          );
                        }
                      }
                    },
                    text: 'Simpan',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
