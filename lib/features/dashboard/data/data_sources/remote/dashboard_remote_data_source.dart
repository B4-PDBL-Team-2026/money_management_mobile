import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/dashboard/data/models/budget_snapshot_model.dart';
import 'package:money_management_mobile/features/dashboard/data/models/unpaid_fixed_cost_model.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

class DashboardRemoteDataSource {
  final Dio dio;
  final _log = Logger('DashboardRemoteDataSource');

  DashboardRemoteDataSource(this.dio);

  Future<BudgetSnapshotModel> fetchBudgetSnapshot() async {
    if (AppEnv.useMockApi) {
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

    try {
      final response = await dio.get('/user/dashboard');

      return BudgetSnapshotModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(
        e,
        _log,
        'Fetch Budget Snapshot',
      );
    } catch (e) {
      _log.severe('Unexpected error while fetching budget snapshot', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat mengambil data dashoboard',
      );
    }
  }
}
