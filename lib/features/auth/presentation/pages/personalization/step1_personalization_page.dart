import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_alert.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_currency_text_field.dart';
import 'package:money_management_mobile/features/auth/presentation/widgets/step_progress_indicator.dart';

class Step1PersonalizationPage extends StatefulWidget {
  const Step1PersonalizationPage({super.key});

  @override
  State<Step1PersonalizationPage> createState() =>
      _Step1PersonalizationPageState();
}

class _Step1PersonalizationPageState extends State<Step1PersonalizationPage> {
  String _selectedCycle = "Bulanan";
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spacing6),
          child: Column(
            children: [
              const StepProgressIndicator(
                currentStep: 1,
                totalSteps: 3,
              ),

              const SizedBox(height: AppSizes.spacing8),
              Text(
                "Siklus Keuangan",
                style: Theme.of(
                  context,
                ).textTheme.displayMedium?.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacing3),
              Text(
                "Pilih siklus keuangan dan masukkan nominal uang saku Anda untuk memulai pencatatan.",
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
              ),
              const SizedBox(height: AppSizes.spacing6),

              Row(
                children: [
                  Expanded(
                    child: _buildCycleCard(
                      "Bulanan",
                      Icons.calendar_month_outlined,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacing4),
                  Expanded(
                    child: _buildCycleCard("Mingguan", Icons.wb_sunny_outlined),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spacing5),

              AppCurrencyTextField(
                controller: _amountController,
                hint: "Rp. 0",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.spacing5),

              const AppAlert(
                message:
                    "Memisahkan uang saku mingguan membantu lebih disiplin mengelola pengeluaran harian.",
              ),

              const SizedBox(height: AppSizes.spacing8),

              AppButton(
                text: "Lanjut Ke Pengeluaran Tetap",
                onPressed: () {
                  context.go(AppRouter.step2Personalization);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCycleCard(String title, IconData icon) {
    bool isSelected = _selectedCycle == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedCycle = title),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusNm),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.beerus,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.trunks,
              size: 20,
            ),
            const SizedBox(width: AppSizes.spacing2),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.primary : AppColors.bulma,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 16,
              color: isSelected ? AppColors.primary : AppColors.trunks,
            ),
          ],
        ),
      ),
    );
  }
}
