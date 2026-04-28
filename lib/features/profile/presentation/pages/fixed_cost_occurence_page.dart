import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/theme/app_text_styles.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FixedCostOccurencePage extends StatelessWidget {
  const FixedCostOccurencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSizes.spacing6,
            AppSizes.spacing6,
            AppSizes.spacing6,
            AppSizes.spacing8,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Biaya tetap',
                    style: AppTextStyles.h1.copyWith(color: AppColors.primary),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push(AppRouter.fixedCostsManagement);
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppSizes.radiusSm),
                        ),
                      ),
                      child: PhosphorIcon(
                        PhosphorIconsRegular.pencil,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
