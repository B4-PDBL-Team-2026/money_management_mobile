/// Dilempar ketika Gemini menolak gambar karena bukan struk yang valid,
/// atau gambar tidak dapat diproses (blur, terlalu gelap, dll).
///
/// Ketika exception ini terjadi, user diberi pilihan:
/// - Ambil foto ulang
/// - Pilih gambar baru dari galeri
/// - Tambah manual (ke BatchTransactionFormPage tanpa pre-filled data)
class InvalidReceiptException implements Exception {
  final String message;

  const InvalidReceiptException([
    this.message = 'Gambar yang kamu kirim tidak valid!',
  ]);

  @override
  String toString() => message;
}

/// Dilempar ketika semua API key Gemini sedang terkena rate limit / cooldown.
///
/// Ketika exception ini terjadi, user hanya diberi pilihan:
/// - Kembali ke beranda
class RateLimitException implements Exception {
  final String message;

  const RateLimitException([
    this.message =
        'Semua API key sedang limit. Silakan coba beberapa saat lagi.',
  ]);

  @override
  String toString() => message;
}
