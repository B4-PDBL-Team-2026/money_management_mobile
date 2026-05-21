import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/transaction/domain/usecases/parse_receipt_transaction_usecase.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/receipt_scanner_state.dart';

@injectable
class ReceiptScannerCubit extends Cubit<ReceiptScannerState> {
  final ParseReceiptTransactionUseCase _parseReceiptTransactionUseCase;

  ReceiptScannerCubit(this._parseReceiptTransactionUseCase)
      : super(ReceiptScannerInitial());

  Future<void> processReceipt(File image) async {
    emit(ReceiptScannerLoading());
    try {
      final items = await _parseReceiptTransactionUseCase(image);
      emit(ReceiptScannerSuccess(items));
    } catch (e) {
      emit(ReceiptScannerError(e.toString()));
    }
  }
}
