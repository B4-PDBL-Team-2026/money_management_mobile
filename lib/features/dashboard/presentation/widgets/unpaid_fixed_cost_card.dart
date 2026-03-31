import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_container_card.dart';
import 'package:money_management_mobile/features/dashboard/domain/entities/unpaid_fixed_cost_entity.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/unpaid_fixed_cost_detail_bottom_sheet.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

class UnpaidFixedCostCard extends StatelessWidget {
  final UnpaidFixedCostEntity item;
  final VoidCallback? onPay;
  final VoidCallback? onCancel;

  const UnpaidFixedCostCard({
    super.key,
    required this.item,
    this.onPay,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      onTap: () {
        showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => UnpaidFixedCostDetailBottomSheet(
            item: item,
            onPay: onPay,
            onCancel: onCancel,
          ),
        );
      },
      child: AppContainerCard(
        backgroundColor: Colors.white,
        border: Border.all(color: AppColors.beerus, width: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing2,
                    vertical: AppSizes.spacing1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning10,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Text(
                    'Belum dibayar',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.warning100,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jatuh tempo: ${_dueText(item)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
                ),
                Text(
                  'Rp ${CurrencyFormatter.format(item.amount)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _dueText(UnpaidFixedCostEntity item) {
    if (item.cycle == FinancialCycle.monthly) {
      return 'Tanggal ${item.dueValue}';
    }

    const weekdayLabel = {
      1: 'Senin',
      2: 'Selasa',
      3: 'Rabu',
      4: 'Kamis',
      5: 'Jumat',
      6: 'Sabtu',
      7: 'Minggu',
    };

    return weekdayLabel[item.dueValue] ?? '-';
  }
}
