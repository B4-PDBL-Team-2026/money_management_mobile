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
          // Padding horizontal tetap 40 agar konsisten dengan desain sebelumnya
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Column(
            // Mengatur elemen agar tersebar (Space di atas dan tombol di bawah)
            children: [
              const SizedBox(
                height: 60,
              ), // Memberi jarak dari bagian paling atas layar
              // 1. AREA LOGO (Posisinya agak ke atas sesuai gambar)
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(
                    30,
                  ), // Lebih membulat mengikuti gambar
                ),
                child: const Center(
                  child: Text("Logo", style: TextStyle(color: Colors.grey)),
                ),
              ),

              const SizedBox(height: 40),

              // 2. AREA TEKS (Judul dan Deskripsi)
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
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5, // Mengatur jarak antar baris teks deskripsi
                ),
              ),

              // 3. SPACER (Inilah kuncinya agar tombol terdorong ke paling bawah)
              const Spacer(),

              // 4. AREA TOMBOL (Berada di bagian bawah layar)
              _buildButton(context, "Register", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              }),

              const SizedBox(height: 15),

              _buildButton(context, "Login", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }),

              const SizedBox(height: 20),

              // 5. TEKS TAMBAHAN (Terms of Service di paling bawah sekali)
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

  Widget _buildButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
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
