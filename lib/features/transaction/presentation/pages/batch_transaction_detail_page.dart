import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_management_mobile/core/constants/global_constant.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/batch_transaction_detail_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/batch_transaction_detail_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/batch_transaction_detail_state.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BatchTransactionDetailPage extends StatefulWidget {
  final int batchId;

  const BatchTransactionDetailPage({super.key, required this.batchId});

  @override
  State<BatchTransactionDetailPage> createState() =>
      _BatchTransactionDetailPageState();
}

class _BatchTransactionDetailPageState
    extends State<BatchTransactionDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<BatchTransactionDetailCubit>().getBatchTransactionDetail(
      id: widget.batchId,
    );
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRouter.history);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gohan,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Detail Batch Transaksi',
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
          child:
              BlocBuilder<
                BatchTransactionDetailCubit,
                BatchTransactionDetailState
              >(
                builder: (context, state) {
                  if (state is BatchTransactionDetailLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is BatchTransactionDetailError) {
                    return _ErrorState(
                      message: state.message,
                      onRetry: () => context
                          .read<BatchTransactionDetailCubit>()
                          .getBatchTransactionDetail(id: widget.batchId),
                    );
                  }

                  if (state is BatchTransactionDetailSuccess) {
                    return _DetailContent(detail: state.detail);
                  }

                  return const SizedBox.shrink();
                },
              ),
        ),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final BatchTransactionDetailEntity detail;

  const _DetailContent({required this.detail});

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat(
      'dd MMMM yyyy',
      'id_ID',
    ).format(detail.transactionAt);
    final noteText = (detail.note == null || detail.note!.trim().isEmpty)
        ? '-'
        : detail.note!;

    final totalExpense = detail.items
        .where((item) => item.type == TransactionType.expense)
        .fold(0, (sum, item) => sum + item.amount);

    final totalIncome = detail.items
        .where((item) => item.type == TransactionType.income)
        .fold(0, (sum, item) => sum + item.amount);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
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
                        color: AppColors.lightPrimary,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      ),
                      child: Text(
                        'Batch Transaksi',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const PhosphorIcon(
                      PhosphorIconsRegular.stack,
                      color: AppColors.gohan,
                    ),
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
                  'Rp ${CurrencyFormatter.format(detail.totalAmount)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.gohan,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSizes.spacing3),
                Text(
                  detail.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.gohan,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacing6),

          // Summary income & expense
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _SummaryChip(
                    label: 'Total Pengeluaran',
                    value: 'Rp ${CurrencyFormatter.format(totalExpense)}',
                    color: AppColors.danger100,
                    bgColor: AppColors.danger10,
                  ),
                ),
                const SizedBox(width: AppSizes.spacing3),
                Expanded(
                  child: _SummaryChip(
                    label: 'Total Pemasukan',
                    value: 'Rp ${CurrencyFormatter.format(totalIncome)}',
                    color: AppColors.success100,
                    bgColor: AppColors.success10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacing4),

          // Info tiles
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
          const SizedBox(height: AppSizes.spacing3),
          _InfoTile(
            label: 'Jumlah Item',
            value: '${detail.items.length} transaksi',
            icon: Icons.format_list_numbered_outlined,
          ),

          const SizedBox(height: AppSizes.spacing6),

          // Items list
          Text(
            'Item Transaksi',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.bulma,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.spacing3),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: detail.items.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSizes.spacing2),
            itemBuilder: (context, index) {
              final item = detail.items[index];
              return _BatchItemCard(item: item);
            },
          ),

          const SizedBox(height: AppSizes.spacing6),
        ],
      ),
    );
  }
}

class _BatchItemCard extends StatelessWidget {
  final BatchTransactionDetailItemEntity item;

  const _BatchItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isExpense = item.type == TransactionType.expense;
    final chipBgColor = isExpense ? AppColors.danger10 : AppColors.success10;
    final amountColor = isExpense ? AppColors.danger100 : AppColors.success100;
    final amountPrefix = isExpense ? '-' : '+';
    final categoryIcon =
        GlobalConstant.categoryIconsMapping[item.categoryIcon] ??
        PhosphorIconsRegular.question;

    return GestureDetector(
      onTap: () {
        context.push('${AppRouter.transactionDetailBase}/${item.id}');
      },
      child: AppContainerCard(
        backgroundColor: Colors.white,
        border: Border.all(color: AppColors.beerus, width: 1),
        padding: const EdgeInsets.all(AppSizes.spacing4),
        child: Row(
          children: [
            // Category icon
            Container(
              padding: const EdgeInsets.all(AppSizes.spacing2),
              decoration: BoxDecoration(
                color: chipBgColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: PhosphorIcon(
                categoryIcon,
                color: AppColors.bulma,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSizes.spacing4),

            // Name + category label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppColors.bulma,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSizes.spacing1),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spacing2,
                      vertical: AppSizes.spacing1,
                    ),
                    decoration: BoxDecoration(
                      color: chipBgColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      item.categoryName,
                      style: TextStyle(
                        color: amountColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Text(
              '$amountPrefix Rp ${CurrencyFormatter.format(item.amount)}',
              style: TextStyle(
                color: amountColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.spacing1),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
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
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
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
