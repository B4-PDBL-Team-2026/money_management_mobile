import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/login_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.danger100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Login berhasil!",
                style: TextStyle(color: AppColors.gohan),
              ),
              backgroundColor: AppColors.primary,
            ),
          );

          if (state.requiresOnboarding) {
            context.go(AppRouter.step1Personalization);
          } else {
            context.go(AppRouter.dashboard);
          }
        }

        if (state is LoginError) _showErrorSnackbar(state.message);
      },
      builder: (context, state) {
        final serverErrors = state is LoginValidationError
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
                    const SizedBox(height: AppSizes.spacing9),
                    SvgPicture.asset(
                      'assets/svg/logo.svg',
                      height: 65,
                      width: double.infinity,
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                    Text(
                      "Selamat Datang Kembali",
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                    Text(
                      "Kami senang melihat Anda lagi! Masuk untuk melanjutkan perjalanan keuangan Anda.",
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
                    ),
                    const SizedBox(height: AppSizes.spacing8),
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          context.go(AppRouter.forgotPassword);
                        },
                        child: Text(
                          "Lupa Password?",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.trunks),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing9),
                    AppButton(
                      text: 'Masuk',
                      isLoading: state is LoginLoading,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<LoginCubit>().login(
                            _emailController.text.trim(),
                            _passwordController.text,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: AppSizes.spacing6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum punya akun? ",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.trunks),
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRouter.registration),
                          child: Text(
                            "Daftar di sini",
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
