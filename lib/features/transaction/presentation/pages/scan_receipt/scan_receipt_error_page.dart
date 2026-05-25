import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/transaction/domain/services/image_picker_service.dart';
import 'package:money_management_mobile/injection_container.dart';
import 'package:picons/picons.dart';

/// Jenis error yang terjadi saat scan struk.
enum ScanReceiptErrorType {
  /// Gambar tidak valid â€” berikan 3 pilihan: ambil ulang, galeri, manual.
  invalidImage,

  /// Semua API key limit â€” hanya berikan 1 pilihan: kembali ke beranda.
  rateLimited,
}

/// Halaman yang ditampilkan ketika scan struk gagal.
///
/// Pilihan aksi disesuaikan dengan jenis error:
/// - [ScanReceiptErrorType.invalidImage]: ambil ulang, pilih dari galeri, tambah manual
/// - [ScanReceiptErrorType.rateLimited]: kembali ke beranda
class ScanReceiptErrorPage extends StatelessWidget {
  final ScanReceiptErrorType errorType;
  final String message;

  const ScanReceiptErrorPage({
    super.key,
    required this.errorType,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              _buildIllustration(),
              const SizedBox(height: 32),
              _buildTitle(),
              const SizedBox(height: 12),
              _buildMessage(),
              const Spacer(flex: 3),
              _buildActions(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    final isRateLimit = errorType == ScanReceiptErrorType.rateLimited;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color:
            isRateLimit
                ? AppColors.warning10
                : AppColors.danger10,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          isRateLimit
              ? PiconsRegular.clock
              : PiconsRegular.imageSquare,
          color:
              isRateLimit
                  ? AppColors.warning100
                  : AppColors.danger100,
          size: 56,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final isRateLimit = errorType == ScanReceiptErrorType.rateLimited;
    return Text(
      isRateLimit ? 'Batas Permintaan Tercapai' : 'Gambar Tidak Valid',
      style: AppTextStyles.h1,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage() {
    return Text(
      message,
      style: AppTextStyles.bodyMain.copyWith(color: AppColors.trunks),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActions(BuildContext context) {
    if (errorType == ScanReceiptErrorType.rateLimited) {
      return _buildRateLimitActions(context);
    }
    return _buildInvalidImageActions(context);
  }

  Widget _buildRateLimitActions(BuildContext context) {
    return _ActionButton(
      icon: PiconsRegular.house,
      label: 'Kembali ke Beranda',
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      onTap: () => context.go(AppRouter.dashboard),
    );
  }

  Widget _buildInvalidImageActions(BuildContext context) {
    return Column(
      children: [
        _ActionButton(
          icon: PiconsRegular.camera,
          label: 'Ambil Foto Ulang',
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          onTap: () => context.pushReplacement(AppRouter.scanReceipt),
        ),
        const SizedBox(height: 12),
        _ActionButton(
          icon: PiconsRegular.image,
          label: 'Pilih Gambar Baru',
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.primary,
          onTap: () => _pickFromGallery(context),
        ),
        const SizedBox(height: 12),
        _ActionButton(
          icon: PiconsRegular.pencilSimple,
          label: 'Tambah Manual',
          backgroundColor: AppColors.gohan,
          foregroundColor: AppColors.bulma,
          onTap: () => context.pushReplacement(AppRouter.addBatchTransaction),
        ),
      ],
    );
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    try {
      final imagePickerService = getIt<ImagePickerService>();
      final File? image = await imagePickerService.pickFromGallery();
      if (image != null && context.mounted) {
        context.pushReplacement(AppRouter.scanLoading, extra: image);
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.showError(context, 'Gagal memilih dari galeri: $e');
      }
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: foregroundColor, size: 20),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: AppTextStyles.subtitle.copyWith(
                    color: foregroundColor,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
