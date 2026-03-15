import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/features/auth/presentation/widgets/fixed_cost_item_card.dart';
import 'package:money_management_mobile/features/auth/presentation/widgets/step_progress_indicator.dart';

class Step3PersonalizationPage extends StatelessWidget {
  const Step3PersonalizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fixedCostItems = <_FixedCostSummary>[
      const _FixedCostSummary(
        name: 'Wifi & Internet',
        cycle: 'Bulanan',
        amount: 'Rp 350.000',
        isIn: true,
      ),
      const _FixedCostSummary(
        name: 'Laundry',
        cycle: 'Mingguan',
        amount: 'Rp 75.000',
        isIn: false,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.spacing6),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.spacing6),
                    const StepProgressIndicator(currentStep: 3, totalSteps: 3),
                    const SizedBox(height: AppSizes.spacing8),
                    Text(
                      'Hasil Personalisasi Kamu',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(height: AppSizes.spacing3),
                    Text(
                      'Berdasarkan data yang kamu berikan, ini adalah budget harian yang kami rekomendasikan untukmu. Jangan khawatir, kamu bisa mengubahnya nanti di pengaturan.',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
                    ),
                    const SizedBox(height: AppSizes.spacing6),
                    const _DailyBudgetCard(),
                    const SizedBox(height: AppSizes.spacing6),
                    Text(
                      'Pengeluaran Tetap',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.trunks,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing3),
                    Column(
                      children: fixedCostItems
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSizes.spacing3,
                              ),
                              child: FixedCostItemCard(
                                name: item.name,
                                cycle: item.cycle,
                                amount: item.amount,
                                isIn: item.isIn,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: AppSizes.spacing8),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: 'Sebelumnya',
                            onPressed: () {
                              context.pop();
                            },
                            variant: AppButtonVariant.ghost,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacing2),
                        Expanded(
                          child: AppButton(
                            text: 'Selesai',
                            onPressed: () {
                              context.pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DailyBudgetCard extends StatelessWidget {
  const _DailyBudgetCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing7),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.radiusNm),
      ),
      child: Column(
        children: [
          Text(
            'Budget Harian',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.gohan,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.spacing3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSizes.spacing1),
                child: Text(
                  'Rp',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.gohan,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spacing1),
              Text(
                '85.000',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.gohan,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FixedCostSummary {
  const _FixedCostSummary({
    required this.name,
    required this.cycle,
    required this.amount,
    required this.isIn,
  });

  final String name;
  final String cycle;
  final String amount;
  final bool isIn;
}
