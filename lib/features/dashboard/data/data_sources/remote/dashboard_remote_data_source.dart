import 'package:money_management_mobile/features/dashboard/data/models/budget_snapshot_model.dart';
import 'package:money_management_mobile/features/dashboard/data/models/unpaid_fixed_cost_model.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

class DashboardRemoteDataSource {
  Future<BudgetSnapshotModel> fetchBudgetSnapshot() async {
    return BudgetSnapshotModel(
      timestamp:
          DateTime.now(), // Pakai waktu sekarang agar selalu relevan saat di-test di device
      balance: 750000, // Saldo yang cukup aman
      budgetCycle: FinancialCycle.monthly,
      safetyCeiling: 50000, // Batas atas / Target harian
      safetyFlooring: 30000, // Batas bawah / Survival
      todaySpent: 25000, // Jajan santai, pas di tengah-tengah (50% dari bar)
      todayLimit: 50000, // Limit tetap di target awal
      actualDailyAllowance: 60000, // Kekuatan asli masih kuat (Surplus)
      tomorrowLimitPrediction: 50000, // Prediksi besok tetap aman
      unpaidFixedCosts: const [
        UnpaidFixedCostModel(
          name: 'Sewa Kos',
          amount: 100000,
          cycle: FinancialCycle.monthly,
          dueValue: 30,
        ),
        UnpaidFixedCostModel(
          name: 'Listrik',
          amount: 50000,
          cycle: FinancialCycle.monthly,
          dueValue: 28,
        ),
      ],
    );
  }
}
