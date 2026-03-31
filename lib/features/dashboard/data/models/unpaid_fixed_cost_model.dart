import 'package:money_management_mobile/features/dashboard/domain/entities/unpaid_fixed_cost_entity.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

class UnpaidFixedCostModel extends UnpaidFixedCostEntity {
  const UnpaidFixedCostModel({
    required super.occurrenceId,
    required super.name,
    required super.amount,
    required super.cycle,
    required super.dueValue,
    super.dueDate,
  });

  factory UnpaidFixedCostModel.fromJson(Map<String, dynamic> json) {
    final rawOccurrenceId = json['occurrence_id'] ?? json['id'];
    final rawAmount = json['amount'];
    final rawCycle = json['cycle'] ?? json['cycle_type'] ?? json['cycle_key'];
    final rawDueValue = json['due_value'];
    final dueDate = DateTime.tryParse(json['due_date'] as String? ?? '');

    final cycle = _parseCycle(rawCycle?.toString());
    final dueValue = dueDate != null
        ? (cycle == FinancialCycle.weekly ? dueDate.weekday : dueDate.day)
        : _parseInt(rawDueValue);

    return UnpaidFixedCostModel(
      occurrenceId: _parseInt(rawOccurrenceId),
      name: json['name'] as String,
      amount: _parseInt(rawAmount),
      cycle: cycle,
      dueValue: dueValue,
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

  UnpaidFixedCostEntity toEntity() {
    return UnpaidFixedCostEntity(
      occurrenceId: occurrenceId,
      name: name,
      amount: amount,
      cycle: cycle,
      dueValue: dueValue,
      dueDate: dueDate,
    );
  }
}
