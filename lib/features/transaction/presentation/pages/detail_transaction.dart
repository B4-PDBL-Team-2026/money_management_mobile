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
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_state.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_detail_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_detail_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_detail_state.dart';
import 'package:picons/picons.dart';

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
        titleSpacing: AppSizes.spacing6,
        leadingWidth: 72,
        title: const Text(
          'Detail Transaksi',
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
              onPressed: _goBack,
              icon: const Icon(Icons.arrow_back, color: AppColors.gohan),
            ),
          ),
        ),
        actions: [
          BlocBuilder<TransactionDetailCubit, TransactionDetailState>(
            builder: (context, state) {
              if (state is TransactionDetailSuccess) {
                return Padding(
                  padding: const EdgeInsets.only(
                    right: AppSizes.spacing6,
                    top: AppSizes.spacing2,
                    bottom: AppSizes.spacing2,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.lightPrimary,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.primary),
                      onPressed: () => _openUpdateDialog(state.transactionDetail),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing6),
          child: BlocConsumer<TransactionDetailCubit, TransactionDetailState>(
            listener: (context, state) async {
              if (state is TransactionDetailDeleted) {
                AppSnackBar.showSuccess(context, state.message);
                _goBack();
                return;
              }

              if (state is TransactionDetailError) {
                AppSnackBar.showError(context, state.message);
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
    if (!mounted) return;

    context.push(
      AppRouter.editTransaction.replaceFirst(':id', detail.id.toString()),
      extra: detail,
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

    final dashboardMetricState = context.read<DashboardMetricCubit>().state;

    if (dashboardMetricState is DashboardMetricLoaded) {
      final isIncome = detail.type == TransactionType.income;
      final willBeNegative = dashboardMetricState.metrics.balance - detail.amount < 0;
      
      if (isIncome && willBeNegative) {
        AppSnackBar.showWarning(
          context,
          'Penghapusan transaksi ini akan menyebabkan saldo menjadi negatif. Hapus transaksi lain atau tambahkan pemasukan terlebih dahulu.',
        );

        return;
      }
    }

    await context.read<TransactionDetailCubit>().deleteTransaction(
      id: detail.id,
    );
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
    final categoryIcon = _resolveCategoryIcon(category, detail);
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
                  category?.name ?? detail.categoryName,
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
          AppButton(
            text: 'Hapus',
            onPressed: onDeletePressed,
            type: AppButtonType.danger,
            variant: AppButtonVariant.ghost,
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

  IconData _resolveCategoryIcon(
    CategoryEntity? category,
    TransactionDetailEntity detail,
  ) {
    if (category?.icon != null) {
      return GlobalConstant.categoryIconsMapping[category!.icon] ??
          PiconsRegular.question;
    }

    if (detail.categoryIcon != null) {
      return GlobalConstant.categoryIconsMapping[detail.categoryIcon!] ??
          PiconsRegular.question;
    }

    if (category == null) {
      return PiconsRegular.question;
    }

    return PiconsRegular.question;
  }

  // TODO: refactor ini di masa depan menggunakan enum terpisah di entitas transaction detail agar lebih type-safe dan mudah di-maintain
  String _resolveSourceText(String source) {
    return switch (source) {
      'manual' => 'Pencatatan Manual',
      'fixed_cost_payment' => 'Pembayaran Biaya Tetap',
      'initial_balance' => 'Saldo Awal',
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
            'Detail transaksi belum bisa dimuat nih',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.bulma),
          ),
          const SizedBox(height: AppSizes.spacing4),
          AppButton(
            text: 'Coba lagi',
            onPressed: onRetry,
            variant: AppButtonVariant.ghost,
          ),
        ],
      ),
    );
  }
}
