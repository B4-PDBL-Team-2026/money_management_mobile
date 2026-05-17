import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class BatchTransactionItemModel {
  final String name;
  final int amount;
  final int categoryId;
  final TransactionType type;
  final String? note;

  const BatchTransactionItemModel({
    required this.name,
    required this.amount,
    required this.categoryId,
    required this.type,
    this.note,
  });

  factory BatchTransactionItemModel.fromEntity(TransactionEntity entity) {
    return BatchTransactionItemModel(
      name: entity.name.trim(),
      amount: entity.amount,
      categoryId: entity.categoryId,
      type: entity.type,
      note: _normalizeText(entity.note),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'categoryId': categoryId,
      'type': type.value,
      'note': note,
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