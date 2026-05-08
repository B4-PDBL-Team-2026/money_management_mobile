import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';

class VoiceErrorView extends StatelessWidget {
  final String rawInput;
  final VoidCallback onReset;

  const VoiceErrorView({
    super.key,
    required this.rawInput,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 60),

          // Error icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.danger100.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.warning_rounded,
                color: AppColors.danger100, size: 36),
          ),

          const SizedBox(height: 24),

          Text(
            'Maaf, Format Tidak\nSesuai',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.bulma,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 16),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.trunks,
                height: 1.6,
              ),
              children: [
                const TextSpan(
                    text: 'Kami belum bisa memproses kalimat\nseperti '),
                if (rawInput.isNotEmpty)
                  TextSpan(
                    text: '"$rawInput"',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700,
                      color: AppColors.bulma,
                    ),
                  ),
                const TextSpan(
                  text:
                  '. Mohon ikuti\nstruktur standar agar pencatatan\nkeuangan Anda lebih akurat.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Format hint card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lightbulb_outline_rounded,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gunakan format berikut:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.bulma,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.gohan,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_rounded,
                                color: AppColors.primary, size: 18),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Contoh: Beli Nasi Goreng seharga 25000 Hari ini',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                  color: AppColors.bulma,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onReset,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: Text(
                'Coba Lagi',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}