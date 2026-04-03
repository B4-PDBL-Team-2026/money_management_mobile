import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
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
    return AppContainerCard(
      padding: EdgeInsets.only(left: AppSizes.spacing4),
      backgroundColor: Colors.white,
      child: Row(
        children: [
          Text(
            'Saldo sebenarnya',
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
