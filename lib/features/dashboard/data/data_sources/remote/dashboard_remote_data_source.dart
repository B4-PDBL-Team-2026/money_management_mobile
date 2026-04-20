import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/dashboard/data/models/budget_snapshot_model.dart';
import 'package:money_management_mobile/features/dashboard/data/models/unpaid_fixed_cost_model.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';

@LazySingleton()
class DashboardRemoteDataSource {
  final Dio dio;
  final _log = Logger('DashboardRemoteDataSource');

  DashboardRemoteDataSource(this.dio);

  Future<List<UnpaidFixedCostModel>> fetchUnpaidFixedCostTemplate() async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(seconds: 1));

      return [
        UnpaidFixedCostModel(
          occurrenceId: 1,
          name: 'Sewa Kos',
          amount: 100000,
          cycle: FinancialCycle.monthly,
          dueValue: 30,
          dueDate: DateTime(2026, 4, 30),
        ),
        UnpaidFixedCostModel(
          occurrenceId: 2,
          name: 'Listrik',
          amount: 50000,
          cycle: FinancialCycle.monthly,
          dueValue: 28,
          dueDate: DateTime(2026, 4, 28),
        ),
      ];
    }

    try {
      final response = await dio.get('/fixed-costs/occurrences');
      final rawOccurrences =
          response.data['data'] as List<dynamic>? ?? <dynamic>[];

      return rawOccurrences
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .where((item) {
            final status = item['status']?.toString().toLowerCase() ?? '';
            final paidAt = item['paid_at'];
            final voidedAt = item['voided_at'];
            final isUnpaidStatus = status == 'pending' || status == 'overdue';
            return isUnpaidStatus && paidAt == null && voidedAt == null;
          })
          .map(UnpaidFixedCostModel.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(
        e,
        _log,
        'Fetch Unpaid Fixed Cost Occurrences',
      );
    } catch (e) {
      _log.severe('Unexpected error while fetching unpaid fixed costs', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat mengambil fixed cost yang belum dibayar',
      );
    }
  }

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
        unpaidFixedCosts: [
          UnpaidFixedCostModel(
            occurrenceId: 1,
            name: 'Sewa Kos',
            amount: 100000,
            cycle: FinancialCycle.monthly,
            dueValue: 30,
            dueDate: DateTime(2026, 4, 30),
          ),
          UnpaidFixedCostModel(
            occurrenceId: 2,
            name: 'Listrik',
            amount: 50000,
            cycle: FinancialCycle.monthly,
            dueValue: 28,
            dueDate: DateTime(2026, 4, 28),
          ),
        ],
      );
    }

    try {
      final response = await dio.get('/user/dashboard');
      final dashboardResponse = response.data;

      return BudgetSnapshotModel.fromJson(
        dashboardResponse['data'] as Map<String, dynamic>,
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

  Future<void> confirmFixedCostOccurrence(int occurrenceId) async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    try {
      await dio.post('/fixed-costs/occurrences/$occurrenceId/confirm');
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(
        e,
        _log,
        'Confirm Fixed Cost Occurrence',
      );
    } catch (e) {
      _log.severe('Unexpected error while confirming fixed cost occurrence', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat konfirmasi pembayaran fixed cost',
      );
    }
  }

  Future<void> cancelFixedCostOccurrence(int occurrenceId) async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    try {
      await dio.post('/fixed-costs/occurrences/$occurrenceId/cancel');
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(
        e,
        _log,
        'Cancel Fixed Cost Occurrence',
      );
    } catch (e) {
      _log.severe('Unexpected error while cancelling fixed cost occurrence', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat membatalkan fixed cost',
      );
    }
  }
}
