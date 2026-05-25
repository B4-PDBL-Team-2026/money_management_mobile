import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/add_batch_transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';

@injectable
class ParseReceiptTransactionUseCase {
  final TransactionRepository repository;

  ParseReceiptTransactionUseCase(this.repository);

  Future<AddBatchTransactionEntity> call(
    File image, {
    required List<CategoryEntity> categories,
  }) async {
    return await repository.parseReceiptImage(image, categories: categories);
  }
}
