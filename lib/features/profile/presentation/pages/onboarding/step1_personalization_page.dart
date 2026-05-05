import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_state.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/submit_financial_profile_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/step_progress_indicator.dart';

class Step1PersonalizationPage extends StatefulWidget {
  const Step1PersonalizationPage({super.key});

  @override
  State<Step1PersonalizationPage> createState() =>
      _Step1PersonalizationPageState();
}

class _Step1PersonalizationPageState extends State<Step1PersonalizationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FinancialProfileDraftCubit>().resetDraft();
    context.read<SubmitFinancialProfileCubit>().reset();
    final state = context.read<FinancialProfileDraftCubit>().state;
    if (state.initialBalance > 0) {
      _amountController.text = CurrencyFormatter.format(state.initialBalance);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
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
                    const StepProgressIndicator(currentStep: 1, totalSteps: 4),
                    const SizedBox(height: AppSizes.spacing7),
                    Text(
                      'Atur Saldo Awal',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spacing2),
                    Text(
                      'Masukkin saldo awal kamu untuk mulai.',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
                    ),
                    const SizedBox(height: AppSizes.spacing10),
                    AppAlert(
                      message:
                          'Secara default, saldo kamu akan dibagi rata untuk satu bulan ke depan. Pembagian dimulai berdasarkan tanggal hari ini.',
                    ),
                    const SizedBox(height: AppSizes.spacing5),
                    AppCurrencyTextField(
                      controller: _amountController,
                      hint: 'Rp. 0',
                      textAlign: TextAlign.center,
                      max: 1000000000,
                      validator: (value) {
                        if (value == null) {
                          return requiredFieldMessage('Saldo awal');
                        }

                        if (value <= 0) {
                          return positiveNumberMessage('Saldo awal');
                        }

                        if (value > 1000000000) {
                          return maxValueMessage('Saldo awal', 1000000000);
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spacing10),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: 'Kembali',
                            variant: AppButtonVariant.ghost,
                            onPressed: () {
                              context.read<SessionCubit>().logout();
                              context.go(AppRouter.welcome);
                            },
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacing4),
                        Expanded(
                          child: AppButton(
                            text: 'Selanjutnya',
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context
                                    .read<FinancialProfileDraftCubit>()
                                    .updateInitialBalance(
                                      CurrencyFormatter.parse(
                                        _amountController.text,
                                      ),
                                    );

                                context.push(AppRouter.step2Personalization);
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
}
