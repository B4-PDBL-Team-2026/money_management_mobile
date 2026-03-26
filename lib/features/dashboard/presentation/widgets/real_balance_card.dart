import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_container_card.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RealBalanceCard extends StatefulWidget {
  final int balance;

  const RealBalanceCard({super.key, required this.balance});

  @override
  State<RealBalanceCard> createState() => _RealBalanceCardState();
}

class _RealBalanceCardState extends State<RealBalanceCard> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return AppCardContainer(
      padding: EdgeInsets.only(left: AppSizes.spacing4),
      backgroundColor: AppColors.gohan,
      child: Row(
        children: [
          Text(
            'Saldo rill',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            'Rp ${_isVisible ? CurrencyFormatter.format(widget.balance) : '••••••'}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.bulma,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(AppSizes.spacing4),
              child: PhosphorIcon(
                _isVisible
                    ? PhosphorIconsRegular.eye
                    : PhosphorIconsRegular.eyeSlash,
                size: 20,
                color: AppColors.trunks,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
