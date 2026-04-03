import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';

class OtherSettingsCard extends StatelessWidget {
  final List<Widget> children;

  const OtherSettingsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusNm),
        border: Border.all(color: AppColors.beerus),
      ),
      child: Column(children: children),
    );
  }
}
