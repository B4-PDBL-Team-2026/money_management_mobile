import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/register_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/register_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.danger100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          context.go(AppRouter.step1Personalization);
          return;
        }

        if (state is RegisterError) {
          _showError(state.message);
        }
      },
      builder: (context, state) {
        final serverErrors = state is RegisterValidationError
            ? state.errors
            : null;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Transform.translate(
              offset: Offset(AppSizes.spacing4, 0),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spacing2),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(AppSizes.radiusNm),
                  ),
                  child: IconButton(
                    icon: Icon(
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.spacing6),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppSizes.spacing2),
                    SvgPicture.asset(
                      'assets/svg/logo.svg',
                      height: 65,
                      width: double.infinity,
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                    Text(
                      "Buat Akun Baru",
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                    Text(
                      "Bergabunglah dengan Moco untuk mengelola keuangan Anda dengan lebih baik.",
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
                    ),
                    const SizedBox(height: AppSizes.spacing8),
                    AppTextField(
                      hint: "Nama Lengkap",
                      controller: _nameController,
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: AppColors.trunks,
                      ),
                      errorText: serverErrors?['name']?[0],
                      validator: (name) {
                        final trimmedName = name?.trim() ?? '';

                        if (trimmedName.isEmpty) {
                          return "Nama lengkap wajib diisi.";
                        }

                        if (trimmedName.length > 255) {
                          return "Nama lengkap maksimal 255 karakter.";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                    AppTextField(
                      hint: "Email",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.trunks,
                      ),
                      errorText: serverErrors?['email']?[0],
                      validator: (email) {
                        final trimmedEmail = email?.trim() ?? '';

                        if (trimmedEmail.isEmpty) {
                          return "Email wajib diisi.";
                        }

                        if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                        ).hasMatch(trimmedEmail)) {
                          return "Format email tidak valid.";
                        }

                        if (trimmedEmail.length > 255) {
                          return "Email maksimal 255 karakter.";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                    AppTextField(
                      hint: "Password",
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.trunks,
                      ),
                      errorText: serverErrors?['password']?[0],
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return "Password wajib diisi.";
                        }

                        if (password.length < 8) {
                          return "Password minimal 8 karakter.";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                    AppTextField(
                      hint: "Konfirmasi Password",
                      controller: _confirmPasswordController,
                      isPassword: true,
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.trunks,
                      ),
                      errorText: serverErrors?['confirm_password']?[0],
                      validator: (confirmPassword) {
                        final password = _passwordController.text;

                        if (confirmPassword == null ||
                            confirmPassword.isEmpty) {
                          return "Konfirmasi password wajib diisi.";
                        }

                        if (confirmPassword != password) {
                          return "Konfirmasi password tidak cocok.";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spacing8),
                    AppButton(
                      text: "Daftar",
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<RegisterCubit>().register(
                            _nameController.text.trim(),
                            _emailController.text.trim(),
                            _passwordController.text,
                            _confirmPasswordController.text,
                          );
                        }
                      },
                      isLoading: state is RegisterLoading,
                    ),
                    const SizedBox(height: AppSizes.spacing6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sudah punya akun? ",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.trunks),
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRouter.login),
                          child: Text(
                            "Masuk di sini",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                ),
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
