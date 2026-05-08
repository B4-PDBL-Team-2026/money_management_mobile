import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/voice_waveform_widget.dart';

class VoiceListeningView extends StatelessWidget {
  final String transcript;
  final Duration elapsed;
  final VoidCallback onStop;

  const VoiceListeningView({
    super.key,
    required this.transcript,
    required this.elapsed,
    required this.onStop,
  });

  String _formatElapsed(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Live transcript
          if (transcript.isNotEmpty)
            _LiveTranscriptText(transcript: transcript)
          else
            const SizedBox(height: 72),

          const SizedBox(height: 32),

          // Status pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.danger100,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'MENDENGARKAN...',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.bulma,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _formatElapsed(elapsed),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.trunks,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Waveform
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.secondary.withOpacity(0.15),
                  AppColors.primary.withOpacity(0.10),
                  Colors.transparent,
                ],
              ),
            ),
            child: const Center(child: VoiceWaveformWidget()),
          ),

          const Spacer(),

          // Stop button
          GestureDetector(
            onTap: onStop,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Selesai Bicara',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.bulma,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _LiveTranscriptText extends StatelessWidget {
  final String transcript;
  const _LiveTranscriptText({required this.transcript});

  static final _amountPattern = RegExp(
    r'\d+(?:[.,]\d+)?\s*(?:jt|juta|rb|ribu|k\b)?',
    caseSensitive: false,
  );
  static const _actionWords = {
    'beli', 'dapat', 'dapet', 'bayar', 'transfer', 'terima', 'seharga',
  };

  @override
  Widget build(BuildContext context) {
    final words = transcript.split(' ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.4,
          ),
          children: [
            const TextSpan(text: '"'),
            ...words.map((word) {
              final clean = word.toLowerCase().replaceAll(RegExp(r'[^\w]'), '');
              Color color = AppColors.bulma;
              if (_actionWords.contains(clean)) color = AppColors.primary;
              if (_amountPattern.hasMatch(word)) color = AppColors.secondary;
              return TextSpan(
                text: '$word ',
                style: TextStyle(color: color),
              );
            }),
            const TextSpan(text: '..."'),
          ],
        ),
      ),
    );
  }
}