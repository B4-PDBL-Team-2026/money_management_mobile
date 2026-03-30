import 'package:money_management_mobile/features/transaction/domain/entities/transaction_detail_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class TransactionDetailModel extends TransactionDetailEntity {
  TransactionDetailModel({
    required super.id,
    required super.userId,
    required super.categoryType,
    required super.categoryId,
    required super.fixedCostOccurrenceId,
    required super.type,
    required super.source,
    required super.name,
    required super.amount,
    required super.transactionDate,
    required super.effectiveAt,
    required super.note,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) {
    final typeValue = json['type'] as String?;

    return TransactionDetailModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      categoryType: (json['category_type'] as String?) ?? 'system',
      categoryId: json['category_id'] as int,
      fixedCostOccurrenceId: json['fixed_cost_occurrence_id'] as int?,
      type: _parseTransactionType(typeValue),
      source: (json['source'] as String?) ?? '-',
      name: (json['name'] as String?) ?? '-',
      amount: _parseAmount(json['amount']),
      transactionDate:
          DateTime.tryParse((json['transaction_date'] as String?) ?? '') ??
          DateTime.now(),
      effectiveAt: _parseDateTime(json['effective_at']),
      note: json['note'] as String?,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      deletedAt: _parseDateTime(json['deleted_at']),
    );
  }

  TransactionDetailEntity toEntity() {
    return TransactionDetailEntity(
      id: id,
      userId: userId,
      categoryType: categoryType,
      categoryId: categoryId,
      fixedCostOccurrenceId: fixedCostOccurrenceId,
      type: type,
      source: source,
      name: name,
      amount: amount,
      transactionDate: transactionDate,
      effectiveAt: effectiveAt,
      note: note,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  static int _parseAmount(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    if (value is String) {
      return double.tryParse(value)?.toInt() ?? 0;
    }

    return 0;
  }

  static TransactionType? _parseTransactionType(String? value) {
    if (value == TransactionType.expense.value) {
      return TransactionType.expense;
    }

    if (value == TransactionType.income.value) {
      return TransactionType.income;
    }

    return null;
  }
}
