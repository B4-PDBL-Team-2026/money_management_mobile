import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_alert.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_currency_text_field.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_state.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/step_progress_indicator.dart';

class Step2PersonalizationPage extends StatefulWidget {
  const Step2PersonalizationPage({super.key});

  @override
  State<Step2PersonalizationPage> createState() =>
      _Step2PersonalizationPageState();
}

class _Step2PersonalizationPageState extends State<Step2PersonalizationPage> {
  final TextEditingController _ceilingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<FinancialProfileDraftCubit>().state;
    if (state.safetyCeiling > 0) {
      _ceilingController.text = CurrencyFormatter.format(state.safetyCeiling);
    }
  }

  @override
  void dispose() {
    _ceilingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialProfileDraftCubit, FinancialProfileDraftState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.spacing6),
              child: Column(
                children: [
                  const SizedBox(height: AppSizes.spacing6),
                  const StepProgressIndicator(currentStep: 2, totalSteps: 4),
                  const SizedBox(height: AppSizes.spacing8),
                  Text(
                    'Safety Ceiling',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.spacing3),
                  Text(
                    'Tentukan batas maksimal perhitungan budget harian.',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
                  ),
                  const SizedBox(height: AppSizes.spacing5),
                  AppCurrencyTextField(
                    controller: _ceilingController,
                    hint: 'Rp. 0',
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      context
                          .read<FinancialProfileDraftCubit>()
                          .updateSafetyCeiling(CurrencyFormatter.parse(value));
                    },
                  ),
                  const SizedBox(height: AppSizes.spacing4),
                  const AppAlert(
                    message:
                        'Sistem akan mengerem jatah harian agar tidak melampaui angka ini untuk memproteksi tabungan, namun Anda tetap bebas bertransaksi melebihi batas ini.',
                  ),
                  const SizedBox(height: AppSizes.spacing8),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Sebelumnya',
                          onPressed: context.pop,
                          variant: AppButtonVariant.ghost,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spacing2),
                      Expanded(
                        child: AppButton(
                          text: 'Selanjutnya',
                          onPressed: () {
                            if (state.safetyCeiling <= 0) {
                              _showError(
                                'Batas maksimal perhitungan wajib diisi',
                              );
                              return;
                            }

                            context.push(AppRouter.step3Personalization);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.danger100),
    );
  }
}
