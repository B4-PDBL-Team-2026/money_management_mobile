import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Placeholder Logo (Kotak Abu-abu sesuai gambar)
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.beerus,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
              ),
              const SizedBox(height: AppSizes.spacing8),

              // 2. Judul Halaman
              Text(
                "Forgot Password",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSizes.spacing7),

              // 3. Input Email (Gaya Minimalis sesuai gambar)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing5),
                decoration: BoxDecoration(
                  color: AppColors.beerus,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Email Address",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacing7),

              // 4. Tombol Confirm
              SizedBox(
                width: 120, // Ukuran tombol lebih kecil sesuai gambar
                child: ElevatedButton(
                  onPressed: () {
                    // Logika simulasi pengiriman email reset
                    _showResetDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.beerus,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                  ),
                  child: Text(
                    "Confirm",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Notifikasi sederhana setelah menekan confirm
  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Email Terkirim", style: Theme.of(context).textTheme.headlineMedium),
        content: Text(
          "Instruksi reset password telah dikirim ke ${_emailController.text}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              Navigator.pop(context); // Kembali ke Login
            },
            child: Text(
              "Kembali ke Login",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
