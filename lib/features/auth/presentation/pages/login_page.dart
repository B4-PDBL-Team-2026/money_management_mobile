import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordObscured = true;
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing8),
          child: Column(
            children: [
              Image.asset('assets/images/Logo.png', width: 180, height: 180),
              const SizedBox(height: AppSizes.spacing7),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Login",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: AppSizes.spacing7),

              _buildInput(
                hint: "Email",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSizes.spacing5),

              _buildInput(
                hint: "Password",
                controller: _passwordController,
                isPassword: true,
                obscureText: _isPasswordObscured,
                onSuffixIconPressed: () {
                  setState(() {
                    _isPasswordObscured = !_isPasswordObscured;
                  });
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
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacing7),

              // --- LOGIKA LOGIN YANG SUDAH DIPERBAIKI PRIORITASNYA ---
              SizedBox(
                width: double.infinity,
                height: AppSizes.spacing9,
                child: ElevatedButton(
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
                        _failedAttempts =
                            0; // Reset agar bisa mencoba lagi nanti
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
                  child: const Text("Masuk"),
                ),
              ),

              const SizedBox(height: AppSizes.spacing5),

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

  Widget _buildInput({
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixIconPressed,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: onSuffixIconPressed,
              )
            : null,
      ),
    );
  }
}
