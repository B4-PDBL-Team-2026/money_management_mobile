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
import 'package:money_management_mobile/features/transaction/domain/entities/add_batch_transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_history_entity.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/batch_transaction_submit_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/batch_transaction_submit_state.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/batch_transaction_item_bottom_sheet.dart';
import 'package:picons/picons.dart';

class BatchTransactionFormPage extends StatefulWidget {
  final int? batchId;
  final AddBatchTransactionEntity? initialBatch;

  const BatchTransactionFormPage({super.key, this.batchId, this.initialBatch});

  @override
  State<BatchTransactionFormPage> createState() =>
      _BatchTransactionFormPageState();
}

class _BatchTransactionFormPageState extends State<BatchTransactionFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _dateController = TextEditingController();

  final Map<int, TransactionEntity> _transactionItems = {};

  int get grandTotal {
    return _transactionItems.values.fold(
      0,
      (sum, item) => item.type == TransactionType.expense
          ? sum - item.amount
          : sum + item.amount,
    );
  }

  @override
  void initState() {
    super.initState();

    final batch = widget.initialBatch;
    if (batch != null) {
      // Pre-fill header dari hasil scan Gemini
      _titleController.text = batch.name;
      _dateController.text = _formatDate(batch.transactionAt);
      _noteController.text = batch.note ?? '';

      // Pre-fill items
      for (var i = 0; i < batch.items.length; i++) {
        final item = batch.items[i];
        final id = DateTime.now().microsecondsSinceEpoch + i;
        _transactionItems[id] = TransactionEntity(
          id: id,
          name: item.name,
          amount: item.amount,
          type: item.type,
          categoryId: item.categoryId,
          transactionAt: item.transactionAt,
          note: item.note,
        );
      }
    } else {
      _dateController.text = _formatDate(DateTime.now());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) =>
      DateFormat('d MMMM yyyy', 'id_ID').format(date);

  DateTime get _transactionDate {
    try {
      return DateFormat('d MMMM yyyy', 'id_ID').parse(_dateController.text);
    } catch (_) {
      return DateTime.now();
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _transactionDate,
      firstDate: DateTime(_transactionDate.year - 3),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.gohan,
            onSurface: AppColors.bulma,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      _dateController.text = _formatDate(picked);
    }
  }

  void _openAddItemSheet() {
    _openItemSheet(mode: BatchItemMode.add, existingItem: null);
  }

  void _openEditItemSheet(TransactionEntity item) {
    _openItemSheet(mode: BatchItemMode.edit, existingItem: item);
  }

  Future<void> _openItemSheet({
    required BatchItemMode mode,
    required TransactionEntity? existingItem,
  }) async {
    final categoryState = context.read<CategoryCubit>().state;
    List<CategoryEntity> expense = [];
    List<CategoryEntity> income = [];

    if (categoryState is CategoryLoaded) {
      expense = categoryState.expenseCategories;
      income = categoryState.incomeCategories;
    }

    final transactionItem = await showModalBottomSheet<TransactionEntity>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusNm),
        ),
      ),
      builder: (_) => BatchTransactionItemBottomSheet(
        mode: mode,
        expenseCategories: expense,
        incomeCategories: income,
        initialTransactionDate: _transactionDate,
        initialData: existingItem,
      ),
    );

    if (transactionItem != null) {
      if (mode == BatchItemMode.add) {
        setState(() {
          _transactionItems[transactionItem.id!] = transactionItem;
        });
      } else {
        setState(() {
          _transactionItems[existingItem!.id!] = transactionItem;
        });
      }
    }
  }

  void _resetForm() {
    _titleController.clear();
    _noteController.clear();
    _dateController.clear();
    _transactionItems.clear();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_transactionItems.isEmpty) {
      AppSnackBar.showWarning(context, 'Tambahkan minimal satu item transaksi.');
      return;
    }

    await context.read<BatchTransactionSubmitCubit>().submit(
      id: widget.batchId,
      addBatchTransaction: AddBatchTransactionEntity(
        name: _titleController.text.trim(),
        transactionAt: _transactionDate,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        source: TransactionSource.manual,
        items: _transactionItems.values.toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      BatchTransactionSubmitCubit,
      BatchTransactionSubmitState
    >(
      listener: (context, state) {
        if (state is BatchTransactionSubmitSuccess) {
          _resetForm();

          AppSnackBar.show(
            context: context,
            message: widget.batchId != null
                ? 'Batch transaksi berhasil diperbarui!'
                : 'Batch transaksi berhasil disimpan!',
            backgroundColor: AppColors.primary,
          );

          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRouter.dashboard);
          }
        }

        if (state is BatchTransactionSubmitError) {
          AppSnackBar.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.gohan,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: AppSizes.spacing4,
          title: Text(
            widget.batchId != null
                ? 'Edit Batch Transaksi'
                : 'Buat Batch Transaksi',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: Transform.translate(
            offset: const Offset(AppSizes.spacing4, 0),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spacing2),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.gohan,
                    size: 20,
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
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.spacing6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // â”€â”€ Header fields â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      AppTextField(
                        label: 'Judul / Nama Transaksi',
                        hint: 'Gaji Bulan April',
                        controller: _titleController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return requiredFieldMessage('Judul transaksi');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.spacing4),
                      AppTextField(
                        label: 'Tanggal',
                        hint: 'Pilih tanggal',
                        controller: _dateController,
                        readOnly: true,
                        onTap: _pickDate,
                        prefixIcon: const Icon(
                          PiconsRegular.calendarBlank,
                          color: AppColors.trunks,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacing6),

                      // â”€â”€ Item list header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Item Transaksi',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: AppColors.bulma,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                if (_transactionItems.isNotEmpty) ...[
                                  const SizedBox(height: AppSizes.spacing1),
                                  Text(
                                    'Geser item ke kanan untuk hapus, atau ketuk untuk edit ya!',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: AppColors.trunks),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSizes.spacing3),
                          _AddItemButton(onTap: _openAddItemSheet),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacing4),

                      // â”€â”€ Empty state â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      if (_transactionItems.isEmpty)
                        _EmptyItemsPlaceholder(onTap: _openAddItemSheet)
                      else
                        _ItemList(
                          items: _transactionItems,
                          onTap: _openEditItemSheet,
                          onDismiss: (id) =>
                              setState(() => _transactionItems.remove(id)),
                        ),

                      const SizedBox(height: AppSizes.spacing6),

                      // â”€â”€ Grand total â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      if (_transactionItems.isNotEmpty) ...[
                        _GrandTotalCard(grandTotal: grandTotal),
                        const SizedBox(height: AppSizes.spacing4),
                      ],

                      AppTextField(
                        label: 'Catatan (Opsional)',
                        hint: 'Tambah Keterangan Singkat...',
                        controller: _noteController,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),

              // â”€â”€ Bottom action â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              BlocBuilder<
                BatchTransactionSubmitCubit,
                BatchTransactionSubmitState
              >(
                builder: (context, submitState) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(
                      AppSizes.spacing6,
                      AppSizes.spacing4,
                      AppSizes.spacing6,
                      MediaQuery.of(context).padding.bottom + AppSizes.spacing4,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: AppColors.beerus)),
                    ),
                    child: AppButton(
                      text: 'Simpan',
                      isLoading: submitState is BatchTransactionSubmitLoading,
                      onPressed: _submit,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// â”€â”€ Private sub-widgets â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _AddItemButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddItemButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        child: const Icon(Icons.add, color: AppColors.gohan),
      ),
    );
  }
}

class _EmptyItemsPlaceholder extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyItemsPlaceholder({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.beerus, style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            const Icon(
              PiconsRegular.receiptX,
              size: 40,
              color: AppColors.trunks,
            ),
            const SizedBox(height: AppSizes.spacing3),
            Text(
              'Belum ada item',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.bulma,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.spacing1),
            Text(
              'Ketuk + untuk menambah item transaksi',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  final Map<int, TransactionEntity> items;
  final void Function(TransactionEntity item) onTap;
  final void Function(int id) onDismiss;

  const _ItemList({
    required this.items,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSizes.spacing2),
      itemBuilder: (context, index) {
        final item = items.values.elementAt(index);
        return _BatchItemCard(
          item: item,
          onTap: () => onTap(item),
          onDismiss: () => onDismiss(item.id!),
        );
      },
    );
  }
}

class _BatchItemCard extends StatelessWidget {
  final TransactionEntity item;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _BatchItemCard({
    required this.item,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = item.type == TransactionType.expense;
    final amountColor = isExpense ? AppColors.danger100 : AppColors.success100;
    final amountPrefix = isExpense ? '- ' : '+ ';
    final bgColor = isExpense ? AppColors.danger10 : AppColors.success10;

    final categoryState = context.read<CategoryCubit>().state;
    final category = categoryState is CategoryLoaded
        ? categoryState.getCategoryById(item.categoryId)
        : null;

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing5),
        decoration: BoxDecoration(
          color: AppColors.danger10,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PiconsRegular.trash,
              color: AppColors.danger100,
              size: 24,
            ),
            SizedBox(height: AppSizes.spacing1),
            Text(
              'Hapus',
              style: TextStyle(
                color: AppColors.danger100,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSizes.spacing4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: AppColors.beerus),
          ),
          child: Row(
            children: [
              // Category icon
              ?_buildItemCategoryIcon(bgColor, category),
              const SizedBox(width: AppSizes.spacing3),

              // Name + category label
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.bulma,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.spacing1),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spacing2,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Text(
                        category?.name ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: amountColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.spacing3),

              // Amount
              Text(
                '$amountPrefix Rp ${CurrencyFormatter.format(item.amount)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildItemCategoryIcon(Color bgColor, CategoryEntity? category) {
    if (category == null) {
      return null;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Icon(
        GlobalConstant.categoryIconsMapping[category.icon]!,
        size: 20,
        color: AppColors.bulma,
      ),
    );
  }
}

class _GrandTotalCard extends StatelessWidget {
  final int grandTotal;
  const _GrandTotalCard({required this.grandTotal});

  @override
  Widget build(BuildContext context) {
    final isNegative = grandTotal < 0;
    final display = isNegative
        ? '- Rp ${CurrencyFormatter.format(grandTotal.abs())}'
        : '+ Rp ${CurrencyFormatter.format(grandTotal)}';
    final color = isNegative ? AppColors.danger100 : AppColors.success100;
    final bgColor = isNegative ? AppColors.danger10 : AppColors.success10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Grand total',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.bulma,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSizes.spacing2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.spacing5),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(
            display,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
