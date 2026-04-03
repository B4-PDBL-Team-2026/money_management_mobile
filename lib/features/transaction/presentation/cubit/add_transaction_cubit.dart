import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/usecases/add_transaction_usecase.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/add_transaction_state.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_history_cubit.dart';

@Injectable()
class AddTransactionCubit extends Cubit<AddTransactionState> {
  final AddTransactionUseCase addTransactionUseCase;

  final TransactionHistoryCubit transactionHistoryCubit;
  final DashboardMetricCubit dashboardMetricCubit;

  final _log = Logger('AddTransactionCubit');

  AddTransactionCubit(
    this.addTransactionUseCase,
    this.transactionHistoryCubit,
    this.dashboardMetricCubit,
  ) : super(AddTransactionInitial());

  Future<void> addTransaction({
    required String name,
    required int amount,
    required TransactionType type,
    required int categoryId,
    required DateTime transactionDate,
    String? note,
  }) async {
    _log.info('Add transaction initiated for name: $name');
    emit(AddTransactionLoading());

    try {
      final transaction = await addTransactionUseCase.execute(
        name: name,
        amount: amount,
        type: type,
        categoryId: categoryId,
        transactionDate: transactionDate,
        note: note,
      );

      await Future.wait([
        transactionHistoryCubit.getFreshTransactionHistory(),
        dashboardMetricCubit.fetchDashboardMetrics(),
      ]);

      emit(AddTransactionSuccess(transaction));
    } on ServerException catch (e) {
      emit(AddTransactionError(e.message));
    } on NetworkException catch (e) {
      emit(AddTransactionError(e.message));
    } on UnexpectedException catch (e) {
      emit(AddTransactionError(e.message));
    } on ValidationException catch (e) {
      emit(AddTransactionValidationError(e.fieldErrors));
    } catch (e) {
      if (kDebugMode) {
        emit(AddTransactionError('Terjadi kesalahan: ${e.toString()}'));
      } else {
        emit(
          AddTransactionError(
            'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
    }
  }
}
