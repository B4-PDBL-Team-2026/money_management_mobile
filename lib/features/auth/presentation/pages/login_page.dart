import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Validasi format email
  bool _isEmailValid(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.danger100),
    );
  }

  void _handleLogin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackbar("Email atau password tidak boleh kosong");
      return;
    }

    if (!_isEmailValid(email)) {
      _showErrorSnackbar("Harus format email valid (@gmail.com, dll)");
      return;
    }

    if (password.length < 8) {
      _showErrorSnackbar("Password minimal 8 karakter");
      return;
    }

    context.read<AuthCubit>().login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
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

        if (state is AuthError) _showErrorSnackbar(state.message);
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.spacing6),
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.trunks,
                        ),
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
                        onPressed: _handleLogin,
                        isLoading: state is AuthLoading,
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
                );
              },
            ),
          ),
        );
      },
    );
  }
}
