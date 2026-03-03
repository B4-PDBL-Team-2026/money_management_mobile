import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // --- PERUBAHAN LOGO: Menggunakan Image.asset ---
              Image.asset(
                'assets/images/Logo.png',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40),
              const Text(
                "Moco",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Master your money.\nControl your future.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
              ),

              const Spacer(),

              // --- TOMBOL   REGISTER (Warna: FFA62B) ---
              _buildButton(
                context,
                "Register",
                const Color(0xFFFFA62B),
                Colors.white,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              // --- TOMBOL LOGIN (Warna: 2E5AA7) ---
              _buildButton(
                context,
                "Login",
                const Color(0xFF2E5AA7),
                Colors.white,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),

              const SizedBox(height: 20),
              const Text(
                "By continuing you agree to our Terms of Service",
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi tombol yang dimodifikasi untuk menerima warna custom
  Widget _buildButton(
    BuildContext context,
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ), // Sudut lebih kotak sesuai gambar baru
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
