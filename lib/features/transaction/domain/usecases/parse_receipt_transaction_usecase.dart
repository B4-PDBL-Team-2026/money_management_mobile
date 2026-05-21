import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';

@injectable
class ParseReceiptTransactionUseCase {
  final TransactionRepository repository;

  ParseReceiptTransactionUseCase(this.repository);

  Future<List<TransactionEntity>> call(File image) async {
    return await repository.parseReceiptImage(image);
  }
}
