import 'package:flutter/material.dart';
import 'dart:math';

class OnboardingStep3Page extends StatelessWidget {
  const OnboardingStep3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF2E5AA7),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset('assets/images/Single_logo.png', height: 40),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar Langkah 3 (100%)
              Column(
                children: [
                  LinearProgressIndicator(
                    value: 1.0,
                    backgroundColor: Colors.grey[200],
                    color: const Color(0xFFFFA62B),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Langkah 3",
                        style: TextStyle(
                          color: Color(0xFFFFA62B),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Langkah 3",
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              const Text(
                "Hasil Analisis Kamu",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E5AA7),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Berdasarkan inputmu, AI kami telah membuatkan rencana pengeluaran yang optimal",
                style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 25),

              // Jatah Harian Card (Biru Tua)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 25),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E5AA7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Text(
                      "JATAH HARIANMU",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 4, right: 4),
                          child: Text(
                            "RP",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "85.000",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Box Alokasi Dana
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.pie_chart_outline, color: Colors.grey[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Alokasi Dana",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Circular Chart Section
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomPaint(
                                size: const Size(100, 100),
                                painter: _DonutChartPainter(),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Total",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Text(
                                    "2,5 jt",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        // Legend Section
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _LegendItem(
                                color: Color(0xFF2E5AA7),
                                label: "Kebutuhan",
                                percentage: "50 %",
                              ),
                              SizedBox(height: 12),
                              _LegendItem(
                                color: Color(0xFFFDE89D),
                                label: "Jajan & Hiburan",
                                percentage: "30 %",
                              ),
                              SizedBox(height: 12),
                              _LegendItem(
                                color: Color(0xFF7E97B8),
                                label: "Tabungan",
                                percentage: "20 %",
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),

              const Text(
                "DETAIL TETAP",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              // Detail Item Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.wifi, color: Colors.grey[600], size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Wifi & Internet",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Fixed Cost",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Text(
                      "-Rp 350.000",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Tombol Bawah
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Logika ke halaman berikutnya
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E5AA7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Mulai Bergabung",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Edit Data Sebelumnya",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String percentage;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 11,
              ),
            ),
          ],
        ),
        Text(
          percentage,
          style: const TextStyle(
            color: Color(0xFF2E5AA7),
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 50% Kebutuhan (Color(0xFF2E5AA7)) - Biru Tua
    // 30% Jajan & Hiburan (Color(0xFFFDE89D)) - Kuning
    // 20% Tabungan (Color(0xFF7E97B8)) - Biru Muda

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    // Stroke width for the donut
    const strokeWidth = 16.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt; // To have flat ends between segments

    // Gap in radians (misalnya 2 derajat)
    // Tapi karena desainnya menempel padat atau ada gap dikit? 
    // Di desain ada gap? Kita gambar solid saja dulu atau dikelilingi background
    // Di desain donut chart nya tebal dan terlihat seperti Stack warna-warni

    // Draw background grey circle in case of gaps
    paint.color = Colors.grey[200]!;
    canvas.drawCircle(center, radius - strokeWidth / 2, paint);

    // Kebutuhan (50%) - Start mapping from top (-pi/2)
    double startAngle = -pi / 2;
    double sweepAngle = pi; // 50% of 2pi

    paint.color = const Color(0xFF2E5AA7);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    // Tabungan (20%) - Next
    startAngle += sweepAngle;
    sweepAngle = (20 / 100) * 2 * pi;

    paint.color = const Color(0xFF7E97B8);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    // Jajan & Hiburan (30%) - Last
    startAngle += sweepAngle;
    sweepAngle = (30 / 100) * 2 * pi;

    paint.color = const Color(0xFFFDE89D);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
