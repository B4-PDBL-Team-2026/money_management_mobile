import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/core/error/receipt_exceptions.dart';
import 'package:money_management_mobile/features/category/domain/repositories/category_repository.dart';
import 'package:money_management_mobile/features/transaction/domain/usecases/parse_receipt_transaction_usecase.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/receipt_scanner_state.dart';

@injectable
class ReceiptScannerCubit extends Cubit<ReceiptScannerState> {
  final ParseReceiptTransactionUseCase _parseReceiptTransactionUseCase;
  final CategoryRepository _categoryRepository;

  ReceiptScannerCubit(
    this._parseReceiptTransactionUseCase,
    this._categoryRepository,
  ) : super(ReceiptScannerInitial());

  Future<void> processReceipt(File image) async {
    emit(ReceiptScannerLoading());
    try {
      // Fetch kategori untuk di-inject ke prompt Gemini
      final categories = await _categoryRepository.getCategories();

      final batch = await _parseReceiptTransactionUseCase(
        image,
        categories: categories,
      );
      emit(ReceiptScannerSuccess(batch));
    } on InvalidReceiptException catch (e) {
      emit(ReceiptScannerInvalidImage(e.message));
    } on RateLimitException catch (e) {
      emit(ReceiptScannerRateLimited(e.message));
    } catch (e) {
      emit(ReceiptScannerError(e.toString()));
    }
  }
}
