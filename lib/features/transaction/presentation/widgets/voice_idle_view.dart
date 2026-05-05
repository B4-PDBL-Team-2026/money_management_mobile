import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';

class VoiceIdleView extends StatefulWidget {
  final VoidCallback onStartListening;
  final void Function(String) onSubmitText;

  const VoiceIdleView({
    super.key,
    required this.onStartListening,
    required this.onSubmitText,
  });

  @override
  State<VoiceIdleView> createState() => _VoiceIdleViewState();
}

class _VoiceIdleViewState extends State<VoiceIdleView> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit() {
    final val = _textController.text.trim();
    if (val.isNotEmpty) {
      widget.onSubmitText(val);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            'Ada transaksi apa\nhari ini?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ceritakan pengeluaran atau\npemasukanmu, aku siap mencatat.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.trunks,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // Input card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Mic button
                GestureDetector(
                  onTap: widget.onStartListening,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withOpacity(0.4),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.mic_rounded, color: Colors.white, size: 36),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Tap untuk bicara',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.trunks,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),

                // Divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.trunks.withOpacity(0.2))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'ATAU KETIK',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.trunks,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.trunks.withOpacity(0.2))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Text input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.keyboard_outlined, color: AppColors.trunks, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            hintText: 'Atau ketik transaksi manual...',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.trunks),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _submit,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.send_rounded,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Format guide
          const SizedBox(height: 28),
          Text(
            'PANDUAN FORMAT',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.trunks,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.mediumPrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coba ucapkan format berikut:',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    '[Beli/Dapat] [Nama]\nseharga [Angka] [Hari ini /Kemarin]',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _ExampleCard(text: '"Beli nasi padang seharga 25rb hari ini"'),
          const SizedBox(height: 12),
          _ExampleCard(text: '"Dapat gaji seharga 5jt kemarin"'),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final String text;
  const _ExampleCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.lightPrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.record_voice_over_rounded,
                color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.bulma,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}