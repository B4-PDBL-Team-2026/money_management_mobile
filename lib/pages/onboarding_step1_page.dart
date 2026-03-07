import 'package:flutter/material.dart';
// TAMBAHKAN IMPORT INI:
import 'onboarding_step2_page.dart';

class OnboardingStep1Page extends StatefulWidget {
  const OnboardingStep1Page({super.key});

  @override
  State<OnboardingStep1Page> createState() => _OnboardingStep1PageState();
}

class _OnboardingStep1PageState extends State<OnboardingStep1Page> {
  String _selectedCycle = "Bulanan";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(child: Image.asset('assets/images/Logo.png', height: 100)),
              const SizedBox(height: 20),

              // Progress Bar (Langkah 1 dari 3)
              Column(
                children: [
                  LinearProgressIndicator(
                    value: 0.33,
                    backgroundColor: Colors.grey[200],
                    color: const Color(0xFFFFA62B),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Langkah 1",
                        style: TextStyle(
                          color: Color(0xFFFFA62B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Langkah 3", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Text(
                "Siklus Keuangan",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E5AA7),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Pilih siklus keuangan dan masukkan nominal uang saku Anda untuk memulai pencatatan.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: _buildCycleCard(
                      "Bulanan",
                      Icons.calendar_month_outlined,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildCycleCard("Mingguan", Icons.wb_sunny_outlined),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: "Rp. 0",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF2E5AA7)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Memisahkan uang saku mingguan membantu lebih disiplin mengelola pengeluaran harian.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2E5AA7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // TOMBOL LANJUT (SUDAH DIPERBAIKI LOGIKANYA)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // PINDAH KE STEP 2
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingStep2Page(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E5AA7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Lanjut Ke Pengeluaran Tetap",
                    style: TextStyle(
                      color: Colors.white,
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
    );
  }

  Widget _buildCycleCard(String title, IconData icon) {
    bool isSelected = _selectedCycle == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedCycle = title),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E5AA7) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF2E5AA7), size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const Spacer(),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 16,
              color: isSelected ? const Color(0xFF2E5AA7) : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
