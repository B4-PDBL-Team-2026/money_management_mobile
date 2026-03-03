import 'package:flutter/material.dart';
import 'package:money_management_mobile/pages/login_page.dart';
import 'verification_page.dart';

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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VerificationPage()),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              Image.asset('assets/images/Logo.png', width: 150, height: 150),
              const SizedBox(height: 20),
              const Text(
                "Register",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              _buildInput(hint: "Nama Lengkap", controller: _nameController),
              const SizedBox(height: 20),
              _buildInput(
                hint: "Email",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _buildInput(
                hint: "Password",
                controller: _passwordController,
                isPassword: true,
                obscureText: _isPasswordObscured,
                onSuffixIconPressed: () =>
                    setState(() => _isPasswordObscured = !_isPasswordObscured),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E5AA7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Daftar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // --- PERUBAHAN DI SINI ---
              const SizedBox(height: 20), // Memberikan jarak yang sama
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sudah punya akun?"),
                  TextButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      ),
                    },
                    child: const Text(
                      "Login di sini",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: onSuffixIconPressed,
                )
              : null,
        ),
      ),
    );
  }
}
