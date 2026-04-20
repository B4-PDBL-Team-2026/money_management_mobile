import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_management_mobile/core/constants/global_constant.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_cubit.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_state.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_detail_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_detail_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_detail_state.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TransactionDetailPage extends StatefulWidget {
  final int transactionId;

  const TransactionDetailPage({super.key, required this.transactionId});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionDetailCubit>().getTransactionDetail(
      id: widget.transactionId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gohan,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Detail Transaksi',
          style: TextStyle(color: AppColors.bulma),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing2),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: IconButton(
              onPressed: _goBack,
              icon: const Icon(Icons.arrow_back, color: AppColors.gohan),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing6),
          child: BlocConsumer<TransactionDetailCubit, TransactionDetailState>(
            listener: (context, state) async {
              if (state is TransactionDetailDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.primary,
                  ),
                );
                _goBack();
                return;
              }

              if (state is TransactionDetailError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.danger100,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is TransactionDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is TransactionDetailError) {
                return _ErrorState(onRetry: _refetch);
              }

              if (state is TransactionDetailSuccess) {
                return _DetailContent(
                  detail: state.transactionDetail,
                  onDeletePressed: () =>
                      _showDeleteConfirmationDialog(state.transactionDetail),
                  onUpdatePressed: () =>
                      _openUpdateDialog(state.transactionDetail),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  void _refetch() {
    context.read<TransactionDetailCubit>().getTransactionDetail(
      id: widget.transactionId,
    );
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRouter.history);
  }

  Future<void> _openUpdateDialog(TransactionDetailEntity detail) async {
    final categoryState = context.read<CategoryCubit>().state;

    if (categoryState is! CategoryLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kategori belum siap. Coba lagi sebentar.'),
          backgroundColor: AppColors.warning100,
        ),
      );
      return;
    }

    CategoryEntity? selectedCategory;
    for (final category in categoryState.categories) {
      if (category.id == detail.categoryId) {
        selectedCategory = category;
        break;
      }
    }

    final selectedType = detail.type ?? selectedCategory?.type;

    if (selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tipe transaksi tidak valid untuk update.'),
          backgroundColor: AppColors.warning100,
        ),
      );
      return;
    }

    final payload = await showModalBottomSheet<_UpdateTransactionPayload>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusNm),
        ),
      ),
      builder: (_) => _UpdateTransactionSheet(
        detail: detail,
        categories: categoryState.categories,
        initialType: selectedType,
      ),
    );

    if (payload == null || !mounted) {
      return;
    }

    final success = await context
        .read<TransactionDetailCubit>()
        .updateTransaction(
          id: detail.id,
          name: payload.name,
          amount: payload.amount,
          type: payload.type,
          categoryId: payload.categoryId,
          categoryType: payload.categoryType,
          transactionAt: payload.transactionAt,
          note: payload.note,
        );

    if (!mounted || !success) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transaksi berhasil diperbarui.'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    TransactionDetailEntity detail,
  ) async {
    final isDeleteConfirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Transaksi?'),
          content: const Text(
            'Data transaksi ini akan dihapus permanen. Lanjutkan?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Hapus',
                style: TextStyle(color: AppColors.danger100),
              ),
            ),
          ],
        );
      },
    );

    if (isDeleteConfirmed != true || !mounted) {
      return;
    }

    await context.read<TransactionDetailCubit>().deleteTransaction(
      id: detail.id,
    );
  }
}

class _UpdateTransactionPayload {
  final String name;
  final int amount;
  final TransactionType type;
  final int categoryId;
  final RealCategoryType categoryType;
  final DateTime transactionAt;
  final String? note;

  _UpdateTransactionPayload({
    required this.name,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.categoryType,
    required this.transactionAt,
    required this.note,
  });
}

class _UpdateTransactionSheet extends StatefulWidget {
  final TransactionDetailEntity detail;
  final List<CategoryEntity> categories;
  final TransactionType initialType;

  const _UpdateTransactionSheet({
    required this.detail,
    required this.categories,
    required this.initialType,
  });

  @override
  State<_UpdateTransactionSheet> createState() =>
      _UpdateTransactionSheetState();
}

class _UpdateTransactionSheetState extends State<_UpdateTransactionSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _dateController;
  late final TextEditingController _noteController;

  late TransactionType _selectedType;
  late DateTime _selectedDate;
  late int _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _selectedDate = widget.detail.transactionAt;
    _nameController = TextEditingController(text: widget.detail.name);
    _amountController = TextEditingController(
      text: CurrencyFormatter.format(widget.detail.amount),
    );
    _dateController = TextEditingController(text: _formatDate(_selectedDate));
    _noteController = TextEditingController(text: widget.detail.note ?? '');

    final availableCategories = _categoriesByType(_selectedType);
    final currentCategoryExists = availableCategories.any(
      (item) => item.id == widget.detail.categoryId,
    );

    _selectedCategoryId = currentCategoryExists
        ? widget.detail.categoryId
        : availableCategories.first.id;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _categoriesByType(_selectedType);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.spacing6,
        right: AppSizes.spacing6,
        top: AppSizes.spacing6,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.spacing6,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Transaksi',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.bulma,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSizes.spacing4),
              AppSegmentedControl<TransactionType>(
                segments: const [
                  SegmentedControlItem(
                    value: TransactionType.expense,
                    label: 'Pengeluaran',
                    selectedBackgroundColor: AppColors.danger100,
                  ),
                  SegmentedControlItem(
                    value: TransactionType.income,
                    label: 'Pemasukan',
                    selectedBackgroundColor: AppColors.success100,
                  ),
                ],
                selectedValue: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                    final nextCategories = _categoriesByType(value);
                    _selectedCategoryId = nextCategories.first.id;
                  });
                },
              ),
              const SizedBox(height: AppSizes.spacing4),
              AppTextField(
                label: 'Judul/Nama Transaksi',
                hint: 'Masukkan nama transaksi',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return requiredFieldMessage('Nama transaksi');
                  }

                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spacing4),
              AppCurrencyTextField(
                label: 'Nominal',
                hint: 'Masukkan nominal',
                controller: _amountController,
                max: 1000000000,
                validator: (value) {
                  if (value == null) {
                    return requiredFieldMessage('Nominal');
                  }

                  if (value <= 0) {
                    return positiveNumberMessage('Nominal');
                  }

                  if (value > 1000000000) {
                    return maxValueMessage('Nominal', 1000000000);
                  }

                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spacing4),
              Text(
                'Kategori',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 14,
                  color: AppColors.trunks,
                ),
              ),
              const SizedBox(height: AppSizes.spacing2),
              DropdownButtonFormField<int>(
                initialValue: _selectedCategoryId,
                items: categories
                    .map(
                      (category) => DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() => _selectedCategoryId = value);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacing4),
              AppTextField(
                label: 'Tanggal',
                hint: 'Pilih tanggal transaksi',
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                prefixIcon: const Icon(Icons.calendar_today_outlined),
              ),
              const SizedBox(height: AppSizes.spacing4),
              AppTextField(
                label: 'Catatan (opsional)',
                hint: 'Masukkan catatan',
                controller: _noteController,
                maxLines: null,
                validator: (value) {
                  if (value != null && value.length > 1000) {
                    return maxLengthMessage('Catatan', 1000);
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spacing6),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Batal',
                      onPressed: () => Navigator.of(context).pop(),
                      variant: AppButtonVariant.ghost,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacing3),
                  Expanded(
                    child: AppButton(
                      text: 'Simpan',
                      type: AppButtonType.secondary,
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        Navigator.of(context).pop(
                          _UpdateTransactionPayload(
                            name: _nameController.text.trim(),
                            amount: CurrencyFormatter.parse(
                              _amountController.text,
                            ),
                            type: _selectedType,
                            categoryId: _selectedCategoryId,
                            categoryType: _selectedCategoryType(),
                            transactionAt: _selectedDate,
                            note: _noteController.text.trim().isEmpty
                                ? null
                                : _noteController.text.trim(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<CategoryEntity> _categoriesByType(TransactionType type) {
    final items = widget.categories.where((item) => item.type == type).toList();

    if (items.isEmpty) {
      return [
        CategoryEntity(
          id: widget.detail.categoryId,
          name: 'Kategori #${widget.detail.categoryId}',
          icon: 'question',
          type: type,
          categoryType: RealCategoryType.system,
        ),
      ];
    }

    return items;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _selectedDate = picked;
      _dateController.text = _formatDate(picked);
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  RealCategoryType _selectedCategoryType() {
    for (final category in widget.categories) {
      if (category.id == _selectedCategoryId) {
        return category.categoryType;
      }
    }

    return RealCategoryType.system;
  }
}

class _DetailContent extends StatelessWidget {
  final TransactionDetailEntity detail;
  final VoidCallback onDeletePressed;
  final VoidCallback onUpdatePressed;

  const _DetailContent({
    required this.detail,
    required this.onDeletePressed,
    required this.onUpdatePressed,
  });

  @override
  Widget build(BuildContext context) {
    final category = _findCategory(context, detail.categoryId);
    final transactionType = detail.type ?? category?.type;
    final isExpense = transactionType != TransactionType.income;
    final chipBgColor = isExpense ? AppColors.danger10 : AppColors.success10;
    final chipTextColor = isExpense
        ? AppColors.danger100
        : AppColors.success100;
    final categoryIcon = _resolveCategoryIcon(category);
    final dateLabel = DateFormat(
      'dd MMMM yyyy',
      'id_ID',
    ).format(detail.transactionAt);
    final noteText = (detail.note == null || detail.note!.trim().isEmpty)
        ? '-'
        : detail.note!;
    final sourceText = detail.source.trim().isEmpty ? '-' : detail.source;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppContainerCard(
            backgroundColor: AppColors.primary,
            border: Border.all(color: AppColors.primary, width: 1),
            padding: const EdgeInsets.all(AppSizes.spacing5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spacing3,
                        vertical: AppSizes.spacing1,
                      ),
                      decoration: BoxDecoration(
                        color: chipBgColor,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      ),
                      child: Text(
                        isExpense ? 'Pengeluaran' : 'Pemasukan',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: chipTextColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(categoryIcon, color: AppColors.gohan),
                  ],
                ),
                const SizedBox(height: AppSizes.spacing4),
                Text(
                  'Total Nominal',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.gohan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.spacing2),
                Text(
                  'Rp ${CurrencyFormatter.format(detail.amount)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.gohan,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSizes.spacing3),
                Text(
                  category?.name ?? 'Kategori #${detail.categoryId}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.gohan,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacing6),
          _InfoTile(
            label: 'Judul / Nama Transaksi',
            value: detail.name,
            icon: Icons.edit_outlined,
          ),
          const SizedBox(height: AppSizes.spacing3),
          _InfoTile(
            label: 'Sumber',
            value: _resolveSourceText(sourceText),
            icon: Icons.wallet_outlined,
          ),
          const SizedBox(height: AppSizes.spacing3),
          _InfoTile(
            label: 'Tanggal',
            value: dateLabel,
            icon: Icons.calendar_today_outlined,
          ),
          const SizedBox(height: AppSizes.spacing3),
          _InfoTile(
            label: 'Catatan',
            value: noteText,
            icon: Icons.description_outlined,
            multiline: true,
          ),
          const SizedBox(height: AppSizes.spacing6),
          Text(
            'Aksi',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.bulma,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.spacing3),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Hapus',
                  onPressed: onDeletePressed,
                  type: AppButtonType.danger,
                  variant: AppButtonVariant.ghost,
                ),
              ),
              const SizedBox(width: AppSizes.spacing3),
              Expanded(
                child: AppButton(
                  text: 'Update',
                  onPressed: onUpdatePressed,
                  type: AppButtonType.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing2),
          Text(
            'Perubahan data akan aktif setelah fitur update tersedia.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
          ),
        ],
      ),
    );
  }

  CategoryEntity? _findCategory(BuildContext context, int categoryId) {
    final categoryState = context.read<CategoryCubit>().state;

    if (categoryState is! CategoryLoaded) {
      return null;
    }

    for (final category in categoryState.categories) {
      if (category.id == categoryId) {
        return category;
      }
    }

    return null;
  }

  IconData _resolveCategoryIcon(CategoryEntity? category) {
    if (category == null) {
      return PhosphorIconsRegular.question;
    }

    return GlobalConstant.categoryIconsMapping[category.icon] ??
        PhosphorIconsRegular.question;
  }

  // TODO: refactor ini di masa depan menggunakan enum terpisah di entitas transaction detail agar lebih type-safe dan mudah di-maintain
  String _resolveSourceText(String source) {
    return switch (source) {
      'manual' => 'Pencatatan Manual',
      'fixed_cost_payment' => 'Pembayaran Fixed Cost',
      _ => source,
    };
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool multiline;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainerCard(
      backgroundColor: Colors.white,
      border: Border.all(color: AppColors.beerus, width: 1),
      padding: const EdgeInsets.all(AppSizes.spacing4),
      child: Row(
        crossAxisAlignment: multiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Container(
            width: AppSizes.spacing9,
            height: AppSizes.spacing9,
            decoration: BoxDecoration(
              color: AppColors.lightPrimary,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSizes.spacing3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.trunks,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.spacing1),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.bulma,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Gagal memuat detail transaksi',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.bulma),
          ),
          const SizedBox(height: AppSizes.spacing4),
          AppButton(
            text: 'Coba Lagi',
            onPressed: onRetry,
            variant: AppButtonVariant.ghost,
          ),
        ],
      ),
    );
  }
}
