import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_mobile/core/constants/global_constant.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_cubit.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_state.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_history_entity.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TransactionHistoryItem extends StatelessWidget {
  final TransactionHistoryEntity transaction;

  const TransactionHistoryItem({super.key, required this.transaction});

  static final _batchCategory = CategoryEntity(
    id: 0,
    name: 'Batch',
    icon: 'stack',
    // TODO: ini tidak ada gunanya, tidak ada tipe transaksi yang cocok untuk batch
    type: TransactionType.expense,
    isSystem: true,
  );

  @override
  Widget build(BuildContext context) {
    final categoryState = context.read<CategoryCubit>().state;
    final isCategoryLoaded = categoryState is CategoryLoaded;
    final isBatchTransaction =
        transaction.feedType == TransactionHistoryFeedType.batch;

    final category = isBatchTransaction
        ? _batchCategory
        : isCategoryLoaded
        ? categoryState.getCategoryById(transaction.categoryId)
        : null;

    final isExpense = transaction.type == TransactionType.expense;

    return AppContainerCard(
      backgroundColor: Colors.white,
      child: Row(
        children: [
          ?_buildCategoryIcon(isExpense, isBatchTransaction, category),
          const SizedBox(width: AppSizes.spacing4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.bulma,
                  ),
                ),
                const SizedBox(height: 4),
                ?_buildCategoryName(isExpense, isBatchTransaction, category),
              ],
            ),
          ),
          Text(
            '${isExpense ? '-' : '+'} Rp ${CurrencyFormatter.format(transaction.amount)}',
            style: TextStyle(
              color: isExpense ? AppColors.danger100 : AppColors.success100,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Container? _buildCategoryName(
    bool isExpense,
    bool isBatchTransaction,
    CategoryEntity? category,
  ) {
    if (category == null) {
      return null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing2,
        vertical: AppSizes.spacing1,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(isExpense, isBatchTransaction),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        category.name,
        style: TextStyle(
          color: _getPrimaryColor(isExpense, isBatchTransaction),
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget? _buildCategoryIcon(
    bool isExpense,
    bool isBatchTransaction,
    CategoryEntity? category,
  ) {
    if (category == null) {
      return null;
    }

    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing2),
      decoration: BoxDecoration(
        color: _getBackgroundColor(isExpense, isBatchTransaction),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: PhosphorIcon(
        GlobalConstant.categoryIconsMapping[category.icon]!,
        color: AppColors.bulma,
        size: 24,
      ),
    );
  }

  Color _getPrimaryColor(bool isExpense, bool isBatchTransaction) {
    return isBatchTransaction
        ? AppColors.primary
        : isExpense
        ? AppColors.danger100
        : AppColors.success100;
  }

  Color _getBackgroundColor(bool isExpense, bool isBatchTransaction) {
    return isBatchTransaction
        ? AppColors.lightPrimary
        : isExpense
        ? AppColors.danger10
        : AppColors.success10;
  }
}
