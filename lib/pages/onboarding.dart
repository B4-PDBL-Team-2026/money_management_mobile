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
              const SizedBox(height: 80),

              // 1. Logo Moco (Kembali ke BoxFit.cover sesuai permintaan)
              SizedBox(
                height: 300,
                width: 300,
                child: Image.asset('assets/images/Logo.png', fit: BoxFit.cover),
              ),

              const SizedBox(height: 25),

              // 2. Headline dengan RichText
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                  children: [
                    TextSpan(
                      text: "Kuasai ",
                      style: TextStyle(color: Color(0xFF2E5AA7)),
                    ),
                    TextSpan(
                      text: "Keuanganmu\n",
                      style: TextStyle(color: Color(0xFFFFA62B)),
                    ),
                    TextSpan(
                      text: "dengan Moco",
                      style: TextStyle(color: Color(0xFF2E5AA7)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. Deskripsi Sub-teks
              const Text(
                "Atur jatah harian, catat pengeluaran, dan capai tujuan finansialmu dengan mudah.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
              ),

              const Spacer(),

              // 4. Tombol Daftar dengan Shadow yang Dipertegas
              _buildButton(
                context,
                "Daftar",
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

              // 5. Tombol Masuk dengan Shadow yang Dipertegas
              _buildButton(
                context,
                "Masuk",
                const Color(0xFF2E5AA7),
                Colors.white,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET TOMBOL DENGAN SHADOW YANG LEBIH TERLIHAT ---
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
          // Menaikkan elevation dan mempergelap shadow agar lebih kontras
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
