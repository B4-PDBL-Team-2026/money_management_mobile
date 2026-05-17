import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/features/transaction/data/models/batch_transaction_item_model.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/add_batch_transaction_entity.dart';

class AddBatchTransactionModel {
  final String name;
  final DateTime transactionAt;
  final String? note;
  final BatchTransactionSource source;
  final List<BatchTransactionItemModel> items;

  const AddBatchTransactionModel({
    required this.name,
    required this.transactionAt,
    required this.source,
    required this.items,
    this.note,
  });

  factory AddBatchTransactionModel.fromEntity(AddBatchTransactionEntity entity) {
    return AddBatchTransactionModel(
      name: entity.name.trim(),
      transactionAt: entity.transactionAt,
      note: _normalizeText(entity.note),
      source: entity.source,
      items: entity.items
          .map(BatchTransactionItemModel.fromEntity)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'transactionAt': TimezoneConverter.toUtcString(transactionAt),
      'note': note,
      'source': source.value,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  static String? _normalizeText(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}