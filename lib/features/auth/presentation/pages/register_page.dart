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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isValidEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  void _handleRegister() {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty) {
      _showError("Nama lengkap wajib diisi.");
      return;
    }
    if (!_isValidEmail(email)) {
      _showError("Format email tidak valid.");
      return;
    }
    if (password.length < 8) {
      _showError("Password minimal 8 karakter.");
      return;
    }
    if (password != confirmPassword) {
      _showError("Konfirmasi password tidak cocok.");
      return;
    }

    context.read<RegisterCubit>().register(
      name,
      email,
      password,
      confirmPassword,
    );
  }

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
        }
        if (state is RegisterError) _showError(state.message);
      },
      builder: (context, state) {
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
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.primary,
                    ),
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
                  ),
                  const SizedBox(height: AppSizes.spacing8),
                  AppButton(
                    text: "Daftar",
                    onPressed: _handleRegister,
                    isLoading: state is RegisterLoading,
                  ),
                  const SizedBox(height: AppSizes.spacing6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sudah punya akun? ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.trunks,
                        ),
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
        );
      },
    );
  }
}
