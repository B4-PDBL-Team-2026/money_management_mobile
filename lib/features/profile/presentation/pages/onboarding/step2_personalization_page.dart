import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
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
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ceilingController = TextEditingController();
  final TextEditingController _flooringController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<FinancialProfileDraftCubit>().state;

    if (state.safetyCeiling > 0) {
      _ceilingController.text = CurrencyFormatter.format(state.safetyCeiling);
    }

    if (state.safetyFlooring > 0) {
      _flooringController.text = CurrencyFormatter.format(state.safetyFlooring);
    }
  }

  @override
  void dispose() {
    _ceilingController.dispose();
    _flooringController.dispose();

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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: AppSizes.spacing4),
                    const StepProgressIndicator(currentStep: 2, totalSteps: 4),
                    const SizedBox(height: AppSizes.spacing7),
                    Text(
                      'Batas Atas dan Bawah',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spacing2),
                    Text(
                      'Tetapkan rentang aman pengeluaran harian Anda.',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
                    ),
                    const SizedBox(height: AppSizes.spacing10),
                    _buildFieldHeader(
                      title: 'Batas Atas',
                      tooltip:
                          'Target pengeluaran harian maksimal agar tabungan tetap terjaga.',
                    ),
                    const SizedBox(height: AppSizes.spacing2),
                    AppCurrencyTextField(
                      controller: _ceilingController,
                      max: 1000000000,
                      hint: 'Rp. 0',
                      textAlign: TextAlign.center,
                      validator: (value) {
                        if (value == null) {
                          return requiredFieldMessage('Batas atas');
                        }

                        if (value <= 0) {
                          return positiveNumberMessage('Batas atas');
                        }

                        if (value > state.initialBalance) {
                          return maxValueMessage('Batas atas', state.initialBalance);
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spacing6),
                    _buildFieldHeader(
                      title: 'Batas Bawah',
                      tooltip:
                          'Jatah harian minimum untuk kebutuhan dasar seperti makan dan transportasi.',
                    ),
                    const SizedBox(height: AppSizes.spacing2),
                    AppCurrencyTextField(
                      controller: _flooringController,
                      max: 1000000000,
                      hint: 'Rp. 0',
                      textAlign: TextAlign.center,
                      validator: (value) {
                        if (value == null) {
                          return requiredFieldMessage('Batas bawah');
                        }

                        if (value <= 0) {
                          return positiveNumberMessage('Batas bawah');
                        }

                        final ceilingLimit = CurrencyFormatter.parse(
                          _ceilingController.text,
                        );

                        if (value > ceilingLimit) {
                          return maxValueMessage('Batas bawah', ceilingLimit);
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spacing10),
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
                              if (_formKey.currentState?.validate() ?? false) {
                                final cubit = context
                                    .read<FinancialProfileDraftCubit>();

                                cubit.updateSafetyCeiling(
                                  CurrencyFormatter.parse(
                                    _ceilingController.text,
                                  ),
                                );

                                cubit.updateSafetyFlooring(
                                  CurrencyFormatter.parse(
                                    _flooringController.text,
                                  ),
                                );

                                context.push(AppRouter.step3Personalization);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFieldHeader({required String title, required String tooltip}) {
    return Row(
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.trunks,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: AppSizes.spacing1),
        Tooltip(
          message: tooltip,
          child: const Icon(
            Icons.info_outline,
            size: 16,
            color: AppColors.trunks,
          ),
        ),
      ],
    );
  }
}
