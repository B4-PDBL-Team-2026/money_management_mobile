import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RealBalanceCard extends StatefulWidget {
  final int balance;
  final int safeBalance;

  const RealBalanceCard({
    super.key,
    required this.balance,
    required this.safeBalance,
  });

  @override
  State<RealBalanceCard> createState() => _RealBalanceCardState();
}

class _RealBalanceCardState extends State<RealBalanceCard> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return AppContainerCard(
      padding: const EdgeInsets.all(AppSizes.spacing4),
      backgroundColor: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'Saldo aman digunakan',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.bulma,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const AppHelpTooltip(
                            message:
                                'Perkiraan sisa uang kamu di akhir bulan ini setelah dikurangi tagihan-tagihan yang belum dibayar.',
                            iconColor: AppColors.bulma,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSizes.spacing2),
                    Text(
                      'Rp ${_isVisible ? CurrencyFormatter.format(widget.safeBalance) : '••••••'}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.bulma,
                      ),
                    ),
                  ],
                ),
                if (widget.safeBalance != widget.balance) ...[
                  const SizedBox(height: AppSizes.spacing1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                'Saldo sebenarnya',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const AppHelpTooltip(
                              message:
                                  'Total saldo kamu saat ini dari semua pemasukan yang tercatat. Ingat ya, ini bukan jumlah aman yang bisa kamu belanjakan semuanya!',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSizes.spacing2),
                      Text(
                        'Rp ${_isVisible ? CurrencyFormatter.format(widget.balance) : '••••••'}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSizes.spacing4),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
            child: PhosphorIcon(
              _isVisible
                  ? PhosphorIconsRegular.eye
                  : PhosphorIconsRegular.eyeSlash,
              size: 28,
              color: AppColors.bulma,
            ),
          ),
        ],
      ),
    );
  }
}
