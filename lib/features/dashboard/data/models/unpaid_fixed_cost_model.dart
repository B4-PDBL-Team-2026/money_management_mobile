import 'package:money_management_mobile/features/dashboard/domain/entities/unpaid_fixed_cost_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

class UnpaidFixedCostModel extends UnpaidFixedCostTemplateEntity {
  const UnpaidFixedCostModel({
    required super.occurrenceId,
    required super.categoryId,
    required super.categoryName,
    required super.categoryIcon,
    required super.name,
    required super.amount,
    required super.cycle,
    super.dueDate,
  });

  factory UnpaidFixedCostModel.fromJson(Map<String, dynamic> json) {
    final rawOccurrenceId = json['id'];
    final rawCategory = json['category'];
    final rawAmount = json['amount'];
    final rawCycle = json['cycleType'];
    final dueDate = DateTime.tryParse(json['dueDate'] as String? ?? '');
    final category = rawCategory is Map
        ? Map<String, dynamic>.from(rawCategory)
        : <String, dynamic>{};

    final cycle = _parseCycle(rawCycle?.toString());

    return UnpaidFixedCostModel(
      occurrenceId: _parseInt(rawOccurrenceId),
      categoryId: _parseInt(category['id']),
      categoryName: category['name'] as String? ?? '-',
      categoryIcon: category['icon'] as String? ?? 'question',
      name: json['name'] as String,
      amount: _parseInt(rawAmount),
      cycle: cycle,
      dueDate: dueDate,
    );
  }

  static int _parseInt(dynamic rawValue) {
    if (rawValue is int) {
      return rawValue;
    }

    if (rawValue is double) {
      return rawValue.toInt();
    }

    if (rawValue is String) {
      final normalized = rawValue.split('.').first;
      return int.tryParse(normalized) ?? 0;
    }

    return int.tryParse(rawValue?.toString() ?? '') ?? 0;
  }

  static FinancialCycle _parseCycle(String? rawCycle) {
    final value = rawCycle?.toLowerCase() ?? '';

    if (value.contains('week') || value.contains('minggu')) {
      return FinancialCycle.weekly;
    }

    if (value.contains('month') || value.contains('bulan')) {
      return FinancialCycle.monthly;
    }

    return FinancialCycle.monthly;
  }

  UnpaidFixedCostTemplateEntity toEntity() {
    return UnpaidFixedCostTemplateEntity(
      occurrenceId: occurrenceId,
      categoryId: categoryId,
      categoryName: categoryName,
      categoryIcon: categoryIcon,
      name: name,
      amount: amount,
      cycle: cycle,
      dueDate: dueDate,
    );
  }
}
