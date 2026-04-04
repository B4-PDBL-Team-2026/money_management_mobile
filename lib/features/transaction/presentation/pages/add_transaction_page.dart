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
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_state.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/add_transaction_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/add_transaction_state.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/category_bottom_sheet.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/category_grid_item.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();

  final List<CategoryEntity> _expenseCategories = [];
  final List<CategoryEntity> _incomeCategories = [];

  TransactionType _selectedTransactionType = TransactionType.expense;
  int _selectedCategory = 0;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(_selectedDate);

    final state = context.read<CategoryCubit>().state;

    if (state is CategoryLoaded) {
      _expenseCategories.addAll(state.expenseCategories);
      _incomeCategories.addAll(state.incomeCategories);

      if (_expenseCategories.isNotEmpty) {
        _selectedCategory = _expenseCategories.first.id;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
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

  Future<void> _showCategoryBottomSheet(BuildContext context) async {
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
        categories: _selectedTransactionType == TransactionType.expense
            ? _expenseCategories
            : _incomeCategories,
        selectedCategory: _selectedCategory,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedCategory = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpenseSelected =
        _selectedTransactionType == TransactionType.expense;
    final currentCategories = isExpenseSelected
        ? _expenseCategories
        : _incomeCategories;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Tambah Transaksi',
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
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            context.go(AppRouter.dashboard);
          }
        },
        child: BlocConsumer<AddTransactionCubit, AddTransactionState>(
          listener: (context, state) {
            if (state is AddTransactionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Transaksi berhasil ditambahkan!",
                    style: TextStyle(color: AppColors.gohan),
                  ),
                  backgroundColor: AppColors.primary,
                ),
              );

              context.go(AppRouter.dashboard);
            }

            if (state is AddTransactionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: TextStyle(color: AppColors.gohan),
                  ),
                  backgroundColor: AppColors.danger100,
                ),
              );
            }
          },
          builder: (context, state) {
            final serverErrors = state is AddTransactionValidationError
                ? state.errors
                : null;

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.spacing6),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppSegmentedControl<TransactionType>(
                        isDisabled: state is AddTransactionLoading,
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
                        selectedValue: _selectedTransactionType,
                        onChanged: (value) {
                          setState(() {
                            _selectedTransactionType = value;
                            _selectedCategory = 0;

                            if (value == TransactionType.expense) {
                              if (_expenseCategories.isNotEmpty) {
                                _selectedCategory = _expenseCategories.first.id;
                              }
                            } else {
                              if (_incomeCategories.isNotEmpty) {
                                _selectedCategory = _incomeCategories.first.id;
                              }
                            }
                          });
                        },
                      ),
                      const SizedBox(height: AppSizes.spacing4),
                      AppCurrencyTextField(
                        label: 'Nominal',
                        hint: 'Masukkan jumlah transaksi',
                        controller: _amountController,
                        isDisabled: state is AddTransactionLoading,
                        errorText: serverErrors?['amount']?[0],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nominal tidak boleh kosong';
                          }

                          final numericValue = CurrencyFormatter.parse(value);

                          if (numericValue <= 0) {
                            return 'Nominal harus lebih besar dari nol';
                          }

                          final fashboardMetricState = context
                              .read<DashboardMetricCubit>()
                              .state;

                          if (fashboardMetricState is DashboardMetricLoaded) {
                            if (_selectedTransactionType ==
                                    TransactionType.expense &&
                                numericValue >
                                    fashboardMetricState.metrics.balance) {
                              return 'Nominal pengeluaran tidak boleh lebih besar dari saldo saat ini';
                            }
                          }

                          if (numericValue > 1000000000) {
                            return 'Nominal tidak boleh lebih dari 1.000.000.000';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.spacing4),
                      AppTextField(
                        label: 'Judul/Nama Transaksi',
                        hint: 'Contoh: Geprek Cibus',
                        controller: _nameController,
                        isDisabled: state is AddTransactionLoading,
                        errorText: serverErrors?['name']?[0],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Judul transaksi tidak boleh kosong';
                          }

                          if (value.length > 255) {
                            return 'Judul transaksi tidak boleh lebih dari 255 karakter';
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
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontSize: 14,
                                  color: AppColors.trunks,
                                ),
                          ),

                          GestureDetector(
                            onTap: () => _showCategoryBottomSheet(context),
                            child: Text(
                              'Lihat semua',
                              style: Theme.of(context).textTheme.bodyMedium
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
                            isDisabled: state is AddTransactionLoading,
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
                        onTap: () => _pickDate(context),
                        prefixIcon: const PhosphorIcon(
                          PhosphorIconsRegular.calendarBlank,
                        ),
                        errorText: serverErrors?['transactionAt']?[0],
                        isDisabled: state is AddTransactionLoading,
                      ),
                      const SizedBox(height: AppSizes.spacing4),
                      AppTextField(
                        label: 'Catatan (opsional)',
                        hint: 'Tambah catatan untuk transaksi ini',
                        controller: _noteController,
                        maxLines: null,
                        isDisabled: state is AddTransactionLoading,
                        errorText: serverErrors?['note']?[0],
                        validator: (value) {
                          if (value != null) {
                            if (value.length > 1000) {
                              return 'Catatan tidak boleh lebih dari 1000 karakter';
                            }
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.spacing8),
                      AppButton(
                        isLoading: state is AddTransactionLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AddTransactionCubit>().addTransaction(
                              amount: CurrencyFormatter.parse(
                                _amountController.text,
                              ),
                              name: _nameController.text,
                              categoryId: _selectedCategory,
                              transactionAt: _selectedDate,
                              note: _noteController.text.isEmpty
                                  ? null
                                  : _noteController.text,
                              type: _selectedTransactionType,
                            );
                          }
                        },
                        text: 'Simpan',
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
