import 'package:equatable/equatable.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

abstract class ReceiptScannerState extends Equatable {
  const ReceiptScannerState();

  @override
  List<Object?> get props => [];
}

class ReceiptScannerInitial extends ReceiptScannerState {}

class ReceiptScannerLoading extends ReceiptScannerState {}

class ReceiptScannerSuccess extends ReceiptScannerState {
  final List<TransactionEntity> scannedItems;

  const ReceiptScannerSuccess(this.scannedItems);

  @override
  List<Object?> get props => [scannedItems];
}

class ReceiptScannerError extends ReceiptScannerState {
  final String message;

  const ReceiptScannerError(this.message);

  @override
  List<Object?> get props => [message];
}
