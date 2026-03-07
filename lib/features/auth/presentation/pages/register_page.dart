import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';

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

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

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

    debugPrint("User mendaftar: $name. Menuju verifikasi...");
    context.go(AppRouter.verification);
  }

  void _showError(String message) {
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
              Image.asset('assets/images/Logo.png', width: 150, height: 150),
              const SizedBox(height: AppSizes.spacing5),
              Text(
                "Register",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSizes.spacing7),
              _buildInput(hint: "Nama Lengkap", controller: _nameController),
              const SizedBox(height: AppSizes.spacing5),
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
                onSuffixIconPressed: () =>
                    setState(() => _isPasswordObscured = !_isPasswordObscured),
              ),
              const SizedBox(height: AppSizes.spacing5),
              _buildInput(
                hint: "Konfirmasi Password",
                controller: _confirmPasswordController,
                isPassword: true,
                obscureText: _isConfirmPasswordObscured,
                onSuffixIconPressed: () => setState(
                  () =>
                      _isConfirmPasswordObscured = !_isConfirmPasswordObscured,
                ),
              ),
              const SizedBox(height: AppSizes.spacing8),
              SizedBox(
                width: double.infinity,
                height: AppSizes.spacing9,
                child: ElevatedButton(
                  onPressed: _handleRegister,
                  child: const Text("Daftar"),
                ),
              ),

              // --- PERUBAHAN DI SINI ---
              const SizedBox(
                height: AppSizes.spacing5,
              ), // Memberikan jarak yang sama
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah punya akun?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRouter.login),
                    child: Text(
                      "Login di sini",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              // -------------------------
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
