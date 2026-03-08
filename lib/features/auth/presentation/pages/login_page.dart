import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int _failedAttempts = 0; // Counter untuk kesalahan input

  // Validasi format email
  bool _isEmailValid(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing6),
          child: Column(
            children: [
              const Spacer(),
              SvgPicture.asset(
                'assets/svg/full-logo.svg',
                height: 65,
                width: double.infinity,
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Login",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: AppSizes.spacing6),
              AppTextField(
                hint: "Email",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSizes.spacing4),
              AppTextField(
                hint: "Password",
                controller: _passwordController,
                isPassword: true,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.go(AppRouter.forgotPassword);
                  },
                  child: Text(
                    "Lupa Password?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              const Spacer(),
              AppButton(
                text: 'Masuk',
                onPressed: () {
                  String email = _emailController.text;
                  String password = _passwordController.text;

                  // 1. Validasi Input Kosong & Format Email
                  if (email.isEmpty || password.isEmpty) {
                    _showErrorSnackbar(
                      "Email atau password tidak boleh kosong",
                    );
                    return;
                  }

                  if (!_isEmailValid(email)) {
                    _showErrorSnackbar(
                      "Harus format email valid (@gmail.com, dll)",
                    );
                    return;
                  }

                  // 2. CEK KECOCOKAN DATA (Prioritas Utama agar Sukses bisa muncul)
                  bool isAuthSuccess =
                      (email == "admin@gmail.com" && password == "12345678");

                  if (isAuthSuccess) {
                    _failedAttempts = 0; // Reset percobaan jika sukses
                    context.go(AppRouter.loginSuccess);
                  } else {
                    // 3. JIKA DATA SALAH, baru jalankan logika error/penalti di sini
                    setState(() {
                      _failedAttempts++;
                    });

                    // Cek apakah sisa percobaan sudah habis (Max 5x)
                    if (_failedAttempts >= 5) {
                      _showErrorSnackbar(
                        "Terlalu banyak percobaan. Silakan reset password.",
                      );
                      _failedAttempts = 0; // Reset agar bisa mencoba lagi nanti
                      context.go(AppRouter.forgotPassword);
                    }
                    // Cek syarat keamanan minimal karakter
                    else if (password.length < 8) {
                      _showErrorSnackbar(
                        "Email atau password salah (Min. 8 Karakter)",
                      );
                    }
                    // Pesan kesalahan standar dengan info sisa kesempatan
                    else {
                      _showErrorSnackbar(
                        "Email atau password salah (${5 - _failedAttempts} kesempatan lagi)",
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: AppSizes.spacing2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Belum punya akun?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      context.go(AppRouter.registration);
                    },
                    child: Text(
                      "Daftar Sekarang",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
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
