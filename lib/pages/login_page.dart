import 'package:flutter/material.dart';
import 'login_success_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

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
              Image.asset('assets/images/Logo.png', width: 180, height: 180),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Lupa Password?",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- LOGIKA LOGIN YANG SUDAH DIPERBAIKI PRIORITASNYA ---
              SizedBox(
                width: double.infinity,
                height: 50,
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

                      // Menuju Halaman LoginSuccessPage (Notifikasi Centang)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginSuccessPage(),
                        ),
                      );
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage(),
                          ),
                        );
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E5AA7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Masuk",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Daftar Sekarang",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
        maxLength: isPassword ? 8 : null,
        decoration: InputDecoration(
          hintText: hint,
          counterText: "",
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
