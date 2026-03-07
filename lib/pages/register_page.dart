import 'package:flutter/material.dart';
import 'registration_success_page.dart';

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

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError("Semua field wajib diisi.");
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
        // Tombol kembali lebih kecil
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          // PADDING LUAR: Dikurangi agar blok putih punya ruang bernapas
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Container(
            // PADDING DALAM: Dikurangi agar isi tidak terlalu jauh dari tepi
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 25.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // SANGAT PENTING: Agar tinggi mengikuti isi
              children: [
                // Ukuran logo diperkecil agar tidak makan tempat
                Image.asset('assets/images/Single_logo.png', height: 60),
                const SizedBox(height: 15),
                const Text(
                  "Daftar",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E5AA7),
                  ),
                ),
                const SizedBox(height: 20),

                _buildInput(
                  hint: "Nama Lengkap",
                  controller: _nameController,
                  label: "Nama Lengkap",
                ),
                const SizedBox(height: 12),
                _buildInput(
                  hint: "Email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email_outlined,
                  label: "Email",
                ),
                const SizedBox(height: 12),
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
                const SizedBox(height: 12),
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
                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E5AA7),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sudah punya akun? ",
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                "Masuk di sini",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFA62B),
                  fontSize: 13,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2E5AA7),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 45, // Tinggi input dibatasi agar lebih ramping
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF2E5AA7).withOpacity(0.5)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              prefixIcon: icon != null
                  ? Icon(icon, color: Colors.grey, size: 18)
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                        size: 18,
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
