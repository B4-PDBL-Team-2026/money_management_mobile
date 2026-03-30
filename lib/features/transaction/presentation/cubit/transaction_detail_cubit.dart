import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/transaction/domain/usecases/get_transaction_detail_usecase.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_detail_state.dart';

class TransactionDetailCubit extends Cubit<TransactionDetailState> {
  final GetTransactionDetailUseCase getTransactionDetailUseCase;

  final _log = Logger('TransactionDetailCubit');

  TransactionDetailCubit(this.getTransactionDetailUseCase)
    : super(TransactionDetailInitial());

  Future<void> getTransactionDetail({required int id}) async {
    _log.info('Fetch transaction detail started for transaction id: $id');
    emit(TransactionDetailLoading());

    try {
      final result = await getTransactionDetailUseCase.execute(id: id);
      emit(TransactionDetailSuccess(result));
    } on ServerException catch (e) {
      _log.severe('Server error while fetching transaction detail', e);
      emit(TransactionDetailError(e.message));
    } on NetworkException catch (e) {
      _log.severe('Network error while fetching transaction detail', e);
      emit(TransactionDetailError(e.message));
    } on UnexpectedException catch (e) {
      _log.severe('Unexpected error while fetching transaction detail', e);
      emit(TransactionDetailError(e.message));
    } catch (e) {
      _log.severe('Unhandled error while fetching transaction detail', e);
      if (kDebugMode) {
        emit(TransactionDetailError('Terjadi kesalahan: ${e.toString()}'));
      } else {
        emit(
          TransactionDetailError(
            'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
    }
  }
}
