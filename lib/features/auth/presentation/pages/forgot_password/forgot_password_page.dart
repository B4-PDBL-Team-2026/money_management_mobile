import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/reset_password_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/reset_password_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const AlertDialog(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              ),
              SizedBox(width: AppSizes.spacing4),
              Expanded(child: Text('Mengirim email reset password...')),
            ],
          ),
        );
      },
    );
  }

  void _closeDialogIfOpen(BuildContext context) {
    final rootNavigator = Navigator.of(context, rootNavigator: true);
    if (rootNavigator.canPop()) {
      rootNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordLoading) {
          _showLoadingDialog(context);
          return;
        }

        if (state is ResetPasswordSuccess) {
          _closeDialogIfOpen(context);
          context.push(AppRouter.forgotPasswordSuccess);
          return;
        }

        if (state is ResetPasswordError) {
          _closeDialogIfOpen(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.danger100,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Transform.translate(
            offset: const Offset(AppSizes.spacing4, 0),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spacing2),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(AppSizes.radiusNm),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.gohan,
                    size: 20,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.spacing6),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSizes.spacing12),
                      SvgPicture.asset(
                        'assets/svg/logo.svg',
                        height: 65,
                        width: double.infinity,
                      ),
                      const SizedBox(height: AppSizes.spacing4),
                      Text(
                        'Lupa Password',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(color: AppColors.primary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.spacing4),
                      Text(
                        'Masukkan email Anda untuk menerima instruksi pemulihan akun.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.trunks,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacing8),
                      AppTextField(
                        hint: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.trunks,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email wajib diisi';
                          }

                          final emailRegex = RegExp(
                            r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                          );

                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Format email tidak valid';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.spacing8),
                      AppButton(
                        text: 'Konfirmasi',
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          context
                              .read<ResetPasswordCubit>()
                              .sendVerificationEmail(
                                email: _emailController.text.trim(),
                              );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
