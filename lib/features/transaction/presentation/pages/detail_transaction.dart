import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_management_mobile/core/constants/global_constant.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_container_card.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';
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
  final _nameController = TextEditingController();
  final _sourceController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TransactionDetailCubit>().getTransactionDetail(
      id: widget.transactionId,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sourceController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gohan,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Detail Transaksi'),
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
            listener: (context, state) {
              if (state is TransactionDetailSuccess) {
                _syncControllers(state.transactionDetail);
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
                  nameController: _nameController,
                  sourceController: _sourceController,
                  dateController: _dateController,
                  noteController: _noteController,
                  onDeletePressed: _showNotAvailableSnackBar,
                  onUpdatePressed: _showNotAvailableSnackBar,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  void _syncControllers(TransactionDetailEntity detail) {
    final dateLabel = DateFormat(
      'dd MMMM yyyy',
      'id_ID',
    ).format(detail.transactionDate);

    _nameController.text = detail.name;
    _sourceController.text = detail.source;
    _dateController.text = dateLabel;
    _noteController.text = detail.note ?? '-';
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

  void _showNotAvailableSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur update dan hapus sedang dalam pengembangan.'),
        backgroundColor: AppColors.warning100,
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final TransactionDetailEntity detail;
  final TextEditingController nameController;
  final TextEditingController sourceController;
  final TextEditingController dateController;
  final TextEditingController noteController;
  final VoidCallback onDeletePressed;
  final VoidCallback onUpdatePressed;

  const _DetailContent({
    required this.detail,
    required this.nameController,
    required this.sourceController,
    required this.dateController,
    required this.noteController,
    required this.onDeletePressed,
    required this.onUpdatePressed,
  });

  @override
  Widget build(BuildContext context) {
    final category = _findCategory(context, detail.categoryId);
    final transactionType = detail.type ?? category?.type;
    final isExpense = transactionType != TransactionType.income;
    final nominalColor = isExpense ? AppColors.danger100 : AppColors.success100;
    final categoryIcon = _resolveCategoryIcon(category);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppContainerCard(
            backgroundColor: AppColors.lightPrimary,
            border: Border.all(color: AppColors.mediumPrimary, width: 1),
            child: Column(
              children: [
                Text(
                  'NOMINAL',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSizes.spacing2),
                Text(
                  'Rp ${CurrencyFormatter.format(detail.amount)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: nominalColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSizes.spacing3),
                Row(
                  children: [
                    Icon(categoryIcon, color: AppColors.primary),
                    const SizedBox(width: AppSizes.spacing2),
                    Expanded(
                      child: Text(
                        category?.name ?? 'Kategori #${detail.categoryId}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.bulma,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacing6),
          AppTextField(
            label: 'Judul/Nama Transaksi',
            hint: '-',
            controller: nameController,
            readOnly: true,
            isDisabled: true,
            prefixIcon: const Icon(Icons.edit_outlined),
          ),
          const SizedBox(height: AppSizes.spacing4),
          AppTextField(
            label: 'Sumber',
            hint: '-',
            controller: sourceController,
            readOnly: true,
            isDisabled: true,
            prefixIcon: const Icon(Icons.wallet_outlined),
          ),
          const SizedBox(height: AppSizes.spacing4),
          AppTextField(
            label: 'Tanggal',
            hint: '-',
            controller: dateController,
            readOnly: true,
            isDisabled: true,
            prefixIcon: const Icon(Icons.calendar_today_outlined),
          ),
          const SizedBox(height: AppSizes.spacing4),
          AppTextField(
            label: 'Catatan',
            hint: '-',
            controller: noteController,
            readOnly: true,
            isDisabled: true,
            maxLines: null,
            prefixIcon: const Icon(Icons.description_outlined),
          ),
          const SizedBox(height: AppSizes.spacing6),
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
                child: AppButton(text: 'Update', onPressed: onUpdatePressed),
              ),
            ],
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
