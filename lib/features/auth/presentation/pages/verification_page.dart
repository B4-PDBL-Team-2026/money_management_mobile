import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing8),
          child: Column(
            children: [
              // Logo Placeholder
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.beerus,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
              ),
              const SizedBox(height: AppSizes.spacing9),
              Text(
                "Verification",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSizes.spacing8),

              // Input OTP Box
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) => _buildOtpBox(index)),
              ),
              const SizedBox(height: AppSizes.spacing9),

              // --- TOMBOL VERIFY ---
              SizedBox(
                width: 100,
                height: AppSizes.spacing8,
                child: ElevatedButton(
                  onPressed: () {
                    // 1. Mengambil kode OTP
                    String code = _controllers.map((e) => e.text).join();
                    debugPrint("Kode Verifikasi yang dimasukkan: $code");

                    // 2. Navigasi ke RegistrationSuccessPage (Bukan LoginSuccessPage)
                    context.go(AppRouter.registrationSuccess);
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
                    "Verify",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.beerus,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
