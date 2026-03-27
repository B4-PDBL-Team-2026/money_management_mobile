import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

class ProfileUtils {
  static const List<MapEntry<int, String>> weekdayOptions = [
    MapEntry(1, 'Senin'),
    MapEntry(2, 'Selasa'),
    MapEntry(3, 'Rabu'),
    MapEntry(4, 'Kamis'),
    MapEntry(5, 'Jumat'),
    MapEntry(6, 'Sabtu'),
    MapEntry(7, 'Minggu'),
  ];

  static String buildDueLabel({
    required int dueValue,
    required FinancialCycle frequency,
  }) {
    if (frequency == FinancialCycle.weekly) {
      return weekdayOptions.firstWhere((item) => item.key == dueValue).value;
    }

    return 'Tanggal $dueValue';
  }

  static String buildCycleLabel(FinancialCycle cycle) {
    return switch (cycle) {
      FinancialCycle.weekly => 'Mingguan',
      FinancialCycle.monthly => 'Bulanan',
    };
  }
}
