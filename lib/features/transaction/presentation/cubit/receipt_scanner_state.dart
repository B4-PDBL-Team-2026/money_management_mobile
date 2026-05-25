import 'package:equatable/equatable.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/add_batch_transaction_entity.dart';

abstract class ReceiptScannerState extends Equatable {
  const ReceiptScannerState();

  @override
  List<Object?> get props => [];
}

class ReceiptScannerInitial extends ReceiptScannerState {}

class ReceiptScannerLoading extends ReceiptScannerState {}

class ReceiptScannerSuccess extends ReceiptScannerState {
  final AddBatchTransactionEntity scannedBatch;

  const ReceiptScannerSuccess(this.scannedBatch);

  @override
  List<Object?> get props => [scannedBatch];
}

/// Gambar tidak valid (bukan struk, blur, dll).
/// User diberi pilihan: ambil ulang, galeri, atau tambah manual.
class ReceiptScannerInvalidImage extends ReceiptScannerState {
  final String message;

  const ReceiptScannerInvalidImage(this.message);

  @override
  List<Object?> get props => [message];
}

/// Semua API key Gemini sedang terkena rate limit / cooldown.
/// User hanya diberi pilihan: kembali ke beranda.
class ReceiptScannerRateLimited extends ReceiptScannerState {
  final String message;

  const ReceiptScannerRateLimited(this.message);

  @override
  List<Object?> get props => [message];
}

/// Error umum tak terduga (koneksi, parsing, dll).
class ReceiptScannerError extends ReceiptScannerState {
  final String message;

  const ReceiptScannerError(this.message);

  @override
  List<Object?> get props => [message];
}
