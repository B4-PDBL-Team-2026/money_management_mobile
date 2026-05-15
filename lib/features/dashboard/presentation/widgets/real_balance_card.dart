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
              children: [
                AppHelpTooltip(
                  message:
                      'Estimasi sisa uang Anda di akhir siklus keuangan saat ini setelah dikurangi tagihan yang belum dibayar.',
                  child: Text(
                    'Saldo aman digunakan',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.bulma,
                    ),
                  ),
                ),
                AppHelpTooltip(
                  message:
                      'Saldo total Anda saat ini, akumulasi dari semua pemasukan yang tercatat. Ini bukan jumlah yang aman untuk dibelanjakan.',
                  child: Text(
                    'Saldo sebenarnya',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.trunks,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rp ${_isVisible ? CurrencyFormatter.format(widget.safeBalance) : '••••••'}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.bulma,
                ),
              ),
              Text(
                'Rp ${_isVisible ? CurrencyFormatter.format(widget.balance) : '••••••'}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.trunks,
                ),
              ),
            ],
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
              _isVisible ? PhosphorIconsRegular.eye : PhosphorIconsRegular.eyeSlash,
              size: 28,
              color: AppColors.bulma,
            ),
          ),
        ],
      ),
    );
  }
}
