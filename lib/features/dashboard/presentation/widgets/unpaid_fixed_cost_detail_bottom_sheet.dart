import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/features/dashboard/domain/entities/unpaid_fixed_cost_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

class UnpaidFixedCostDetailBottomSheet extends StatelessWidget {
  final UnpaidFixedCostEntity item;
  final VoidCallback? onPay;
  final VoidCallback? onCancel;

  const UnpaidFixedCostDetailBottomSheet({
    super.key,
    required this.item,
    this.onPay,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSizes.spacing6,
        right: AppSizes.spacing6,
        top: AppSizes.spacing6,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.spacing6,
      ),
      decoration: const BoxDecoration(
        color: AppColors.gohan,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.spacing6),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.beerus,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spacing4),
          Text(
            item.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.spacing4),
          _detailRow(context, 'Status', 'Belum dibayar'),
          const SizedBox(height: AppSizes.spacing2),
          _detailRow(
            context,
            'Frekuensi',
            item.cycle == FinancialCycle.weekly ? 'Mingguan' : 'Bulanan',
          ),
          const SizedBox(height: AppSizes.spacing2),
          _detailRow(context, 'Jatuh tempo', _dueText(item)),
          const SizedBox(height: AppSizes.spacing2),
          _detailRow(
            context,
            'Nominal',
            'Rp ${CurrencyFormatter.format(item.amount)}',
          ),
          const SizedBox(height: AppSizes.spacing5),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Cancel',
                  variant: AppButtonVariant.outlined,
                  type: AppButtonType.danger,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onCancel?.call();
                  },
                ),
              ),
              const SizedBox(width: AppSizes.spacing3),
              Expanded(
                child: AppButton(
                  text: 'Bayar',
                  type: AppButtonType.primary,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onPay?.call();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.trunks,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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
