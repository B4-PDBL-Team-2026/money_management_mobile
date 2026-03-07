import 'package:flutter/material.dart';
// Import login_page dihapus untuk menghilangkan warning 'Unused import'
import 'registration_success_page.dart'; // Import ini wajib ada agar bisa pindah halaman

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

    // Validasi tetap dipertahankan agar data yang masuk benar
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

    debugPrint("User mendaftar: $name. Berhasil.");

    // --- PERUBAHAN UTAMA: Pindah ke halaman sukses ---
    // Menggunakan pushReplacement agar user tidak bisa kembali ke form register
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationSuccessPage()),
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
      backgroundColor: const Color(0xFF2E5AA7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Container(
            padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/Single_logo.png', height: 80),
                const SizedBox(height: 20),
                const Text(
                  "Daftar",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E5AA7),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Bergabunglah dengan Moco untuk mengelola keuangan Anda dengan lebih baik.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                _buildInput(
                  hint: "Nama Lengkap",
                  controller: _nameController,
                  label: "Nama Lengkap",
                ),
                const SizedBox(height: 15),
                _buildInput(
                  hint: "Email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email_outlined,
                  label: "Email",
                ),
                const SizedBox(height: 15),
                _buildInput(
                  hint: "Password",
                  controller: _passwordController,
                  isPassword: true,
                  obscureText: _isPasswordObscured,
                  icon: Icons.lock_outline,
                  label: "Password",
                  onSuffixIconPressed: () => setState(
                    () => _isPasswordObscured = !_isPasswordObscured,
                  ),
                ),
                const SizedBox(height: 15),
                _buildInput(
                  hint: "Konfirmasi Password",
                  controller: _confirmPasswordController,
                  isPassword: true,
                  obscureText: _isConfirmPasswordObscured,
                  icon: Icons.verified_user_outlined,
                  label: "Konfirmasi Password",
                  onSuffixIconPressed: () => setState(
                    () => _isConfirmPasswordObscured =
                        !_isConfirmPasswordObscured,
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E5AA7),
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Daftar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sudah punya akun? ",
              style: TextStyle(color: Colors.white),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                "Masuk di sini",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFA62B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required String hint,
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixIconPressed,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      // Perbaikan: Pakai .start agar tidak error
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2E5AA7),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2E5AA7)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: icon != null
                  ? Icon(icon, color: Colors.grey, size: 20)
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: onSuffixIconPressed,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
