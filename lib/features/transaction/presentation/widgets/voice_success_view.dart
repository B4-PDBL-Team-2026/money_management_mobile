import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class VoiceSuccessView extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback onHome;
  final VoidCallback onDetail;
  final VoidCallback onRecordAgain;

  const VoiceSuccessView({
    super.key,
    required this.transaction,
    required this.onHome,
    required this.onDetail,
    required this.onRecordAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(),

          // Animated check
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (_, v, child) => Transform.scale(scale: v, child: child),
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 32,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.check_rounded,
                  color: AppColors.primary, size: 44),
            ),
          ),

          const SizedBox(height: 28),

          Text(
            'Transaksi Berhasil\nDisimpan!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.bulma,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Catatan keuanganmu telah diperbarui\nsecara otomatis.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.trunks,
              height: 1.6,
            ),
          ),

          const Spacer(),

          // Back to home
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onHome,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
              label: Text(
                'Kembali ke Beranda',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _OutlineButton(label: 'Detail Transaksi', onTap: onDetail),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _OutlineButton(label: 'Catat Lagi', onTap: onRecordAgain),
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.trunks.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.bulma,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}