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

  static final _defaultCategory = CategoryEntity(
    id: 0,
    name: 'Tidak Diketahui',
    icon: 'question',
    type: TransactionType.expense,
    categoryType: RealCategoryType.system,
  );

  const TransactionHistoryItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final categoryState = context.read<CategoryCubit>().state;
    final category = categoryState is CategoryLoaded
        ? categoryState.categories.firstWhere(
            (cat) => cat.id == transaction.categoryId,
            orElse: () => _defaultCategory,
          )
        : _defaultCategory;

    final isExpense = transaction.type == TransactionType.expense;

    return AppContainerCard(
      backgroundColor: Colors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.spacing2),
            decoration: BoxDecoration(
              color: isExpense ? AppColors.danger10 : AppColors.success10,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: PhosphorIcon(
              GlobalConstant.categoryIconsMapping[category.icon]!,
              color: AppColors.bulma,
              size: 24,
            ),
          ),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing2,
                    vertical: AppSizes.spacing1,
                  ),
                  decoration: BoxDecoration(
                    color: isExpense ? AppColors.danger10 : AppColors.success10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: isExpense
                          ? AppColors.danger100
                          : AppColors.success100,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
}
