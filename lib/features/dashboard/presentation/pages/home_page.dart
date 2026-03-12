import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_confirm_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recentTransactions = [
    {
      "id": "2123974",
      "title": "Geprek Bakar",
      "date": "3 Maret 2026",
      "amount": 12000,
      "type": "cash-out",
      "category": "Makan",
    },
    {
      "id": "32454",
      "title": "Uang Saku",
      "date": "2 Maret 2026",
      "amount": 12000,
      "type": "cash-in",
      "category": "Makan",
    },
    {
      "id": "324576",
      "title": "Roti Bakar Coklat Keju",
      "date": "2 Maret 2026",
      "amount": 20000,
      "type": "cash-out",
      "category": "Jajan",
    },
  ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.spacing6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppSizes.radiusXl),
                    bottomRight: Radius.circular(AppSizes.radiusXl),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hai, Alexandra!',
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(color: AppColors.gohan),
                            ),
                            const SizedBox(height: AppSizes.spacing1),
                            Text(
                              'Selamat datang kembali',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.gohan),
                            ),
                          ],
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.beerus,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person, color: AppColors.trunks),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spacing6),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.spacing6),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gohan, width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppSizes.radiusNm),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pengeluaran hari ini',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.gohan,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: AppSizes.spacing2),
                                  Text(
                                    CurrencyFormatter.format(32000),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(color: AppColors.gohan),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(AppSizes.radiusSm),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSizes.spacing2,
                                  vertical: AppSizes.spacing1,
                                ),
                                child: Text(
                                  'IDR',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.spacing2),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSizes.spacing3),
                            decoration: BoxDecoration(
                              color: AppColors.beerus.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.all(
                                Radius.circular(AppSizes.radiusSm),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                  'Sisa ${CurrencyFormatter.format(18000)}',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.gohan,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 16,
                                  color: AppColors.gohan.withValues(alpha: 0.3),
                                ),
                                Expanded(
                                  child: Text(
                                    'Limit ${CurrencyFormatter.format(50000)}',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.gohan,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSizes.spacing4),
                          LinearProgressIndicator(
                            value: 8 / 10,
                            backgroundColor: AppColors.beerus,
                            color: AppColors.secondary,
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusSm,
                            ),
                          ),
                          const SizedBox(height: AppSizes.spacing2),
                          Text(
                            'Kamu sudah pakai 80% hari ini',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.gohan,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCard(
                            context,
                            'Sisa uang saku',
                            CurrencyFormatter.format(680000),
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacing4),
                        Expanded(
                          child: _buildCard(context, 'Hari tersisa', '15 hari'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.spacing6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaksi terbaru',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                    ListView.separated(
                      itemCount: recentTransactions.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final currentTransaction = recentTransactions[index];

                        return Dismissible(
                          key: Key(currentTransaction['id']),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.spacing4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.danger100,
                              borderRadius: BorderRadius.all(
                                Radius.circular(AppSizes.radiusSm),
                              ),
                            ),
                            child: Icon(Icons.delete, color: AppColors.gohan),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              return await AppConfirmDialog.show(
                                context: context,
                                title: 'Hapus transaksi',
                                content:
                                    'Apakah kamu yakin ingin menghapus transaksi ini?',
                                confirmText: 'Hapus',
                                cancelText: 'Batal',
                                confirmButtonType: AppButtonType.danger,
                              );
                            }

                            return false;
                          },
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(AppSizes.radiusSm),
                              ),
                              side: BorderSide(
                                color: AppColors.beerus,
                                width: 1,
                              ),
                            ),
                            title: Text(
                              currentTransaction['title'],
                              style: Theme.of(context).textTheme.bodyLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              currentTransaction['date'],
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  (currentTransaction['type'] == 'cash-out'
                                          ? '- '
                                          : '+ ') +
                                      CurrencyFormatter.format(currentTransaction['amount']),
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color:
                                            currentTransaction['type'] ==
                                                'cash-out'
                                            ? AppColors.danger100
                                            : AppColors.success100,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  currentTransaction['category'],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: AppSizes.spacing3);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spacing10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String amount) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing4),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        border: Border.all(color: AppColors.bulma, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusNm)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.bulma,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.spacing1),
          Text(
            amount,
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(color: AppColors.bulma),
          ),
        ],
      ),
    );
  }
}
