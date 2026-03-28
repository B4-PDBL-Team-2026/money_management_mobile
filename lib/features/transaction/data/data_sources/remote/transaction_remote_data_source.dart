import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/core/data/models/paginated_model.dart';
import 'package:money_management_mobile/core/error/error_handler.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/transaction/data/models/transaction_history_model.dart';
import 'package:money_management_mobile/features/transaction/data/models/transaction_model.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class TransactionRemoteDataSource {
  final Dio dio;
  final _log = Logger('TransactionRemoteDataSource');

  TransactionRemoteDataSource(this.dio);

  Future<TransactionModel> addTransaction(
    TransactionModel transactionModel,
  ) async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(seconds: 1));
      return transactionModel;
    }

    try {
      await dio.post('/transaction', data: transactionModel.toJson());
      return transactionModel;
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, ' Add Transaction');
    } catch (e) {
      _log.severe('Unexpected error while adding transaction', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat menambah transaksi',
      );
    }
  }

  Future<PaginatedModel<TransactionHistoryModel>> getTransaction({
    int? page,
    String? search,
    int? categoryId,
    int? month,
    int? year,
  }) async {
    if (AppEnv.useMockApi) {
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final threeDaysAgo = now.subtract(const Duration(days: 3));

      final items = [
        // --- HARI INI ---
        TransactionHistoryModel(
          id: 1,
          amount: 5000000,
          categoryId: 11,
          name: 'Gaji Bulanan',
          transactionDate: now,
          createdAt: now,
          updatedAt: now,
          type: TransactionType.income,
        ),
        TransactionHistoryModel(
          id: 2,
          amount: 35000,
          categoryId: 1,
          name: 'Makan Siang (Nasi Padang)',
          transactionDate: now,
          createdAt: now,
          updatedAt: now,
          type: TransactionType.expense,
        ),
        TransactionHistoryModel(
          id: 3,
          amount: 15000,
          categoryId: 2,
          name: 'Ojek Online',
          transactionDate: now,
          createdAt: now,
          updatedAt: now,
          type: TransactionType.expense,
        ),

        // --- KEMARIN ---
        TransactionHistoryModel(
          id: 4,
          amount: 150000,
          categoryId: 6,
          name: 'Belanja Mingguan',
          transactionDate: yesterday,
          createdAt: yesterday,
          updatedAt: yesterday,
          type: TransactionType.expense,
        ),
        TransactionHistoryModel(
          id: 5,
          amount: 200000,
          categoryId: 13,
          name: 'Hadiah Ulang Tahun',
          transactionDate: yesterday,
          createdAt: yesterday,
          updatedAt: yesterday,
          type: TransactionType.income,
        ),
        TransactionHistoryModel(
          id: 6,
          amount: 85000,
          categoryId: 5,
          name: 'Tiket Bioskop',
          transactionDate: yesterday,
          createdAt: yesterday,
          updatedAt: yesterday,
          type: TransactionType.expense,
        ),

        // --- 3 HARI LALU ---
        TransactionHistoryModel(
          id: 7,
          amount: 1200000,
          categoryId: 3,
          name: 'Bayar Listrik & WiFi',
          transactionDate: threeDaysAgo,
          createdAt: threeDaysAgo,
          updatedAt: threeDaysAgo,
          type: TransactionType.expense,
        ),
        TransactionHistoryModel(
          id: 8,
          amount: 500000,
          categoryId: 14,
          name: 'Dividen Saham',
          transactionDate: threeDaysAgo,
          createdAt: threeDaysAgo,
          updatedAt: threeDaysAgo,
          type: TransactionType.income,
        ),
        TransactionHistoryModel(
          id: 9,
          amount: 50000,
          categoryId: 8,
          name: 'Donasi Panti Asuhan',
          transactionDate: threeDaysAgo,
          createdAt: threeDaysAgo,
          updatedAt: threeDaysAgo,
          type: TransactionType.expense,
        ),
        TransactionHistoryModel(
          id: 10,
          amount: 25000,
          categoryId: 7,
          name: 'Beli Obat Flu',
          transactionDate: threeDaysAgo,
          createdAt: threeDaysAgo,
          updatedAt: threeDaysAgo,
          type: TransactionType.expense,
        ),
        TransactionHistoryModel(
          id: 11,
          amount: 1000000,
          categoryId: 15,
          name: 'Pinjaman Cair',
          transactionDate: threeDaysAgo,
          createdAt: threeDaysAgo,
          updatedAt: threeDaysAgo,
          type: TransactionType.income,
        ),
      ];

      return PaginatedModel(
        items: items,
        currentPage: page ?? 1,
        totalPages: (items.length / 10).ceil(),
        totalItems: items.length,
      );
    }

    try {
      final response = await dio.get(
        '/transaction/transactions',
        queryParameters: {
          'page': page,
          'search': search,
          'categoryId': categoryId,
          'month': month,
          'year': year,
        },
      );

      return PaginatedModel.fromJson(
        response.data,
        TransactionHistoryModel.fromJson,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleRemoteException(e, _log, ' Get Transaction');
    } catch (e) {
      _log.severe('Unexpected error while fetching transaction', e);
      throw UnexpectedException(
        'Terjadi kesalahan sistem saat mengambil transaksi',
      );
    }
  }
}
