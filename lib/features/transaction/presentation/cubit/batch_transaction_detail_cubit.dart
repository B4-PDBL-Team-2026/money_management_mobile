import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_messages.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/batch_transaction_detail_state.dart';

@Injectable()
class BatchTransactionDetailCubit extends Cubit<BatchTransactionDetailState> {
  final TransactionRepository _transactionRepository;
  final _log = Logger('BatchTransactionDetailCubit');

  BatchTransactionDetailCubit(this._transactionRepository)
    : super(BatchTransactionDetailInitial());

  Future<void> getBatchTransactionDetail({required int id}) async {
    _log.info('Fetch batch transaction detail for id: $id');
    emit(BatchTransactionDetailLoading());

    try {
      final result = await _transactionRepository.getBatchTransactionDetail(
        id: id,
      );
      emit(BatchTransactionDetailSuccess(result));
    } on ServerException catch (e, stackTrace) {
      _log.severe(
        'Server error fetching batch transaction detail',
        e,
        stackTrace,
      );
      emit(BatchTransactionDetailError(e.message));
    } on NetworkException catch (e, stackTrace) {
      _log.severe(
        'Network error fetching batch transaction detail',
        e,
        stackTrace,
      );
      emit(BatchTransactionDetailError(e.message));
    } on NotFoundException catch (e, stackTrace) {
      _log.severe('Not found fetching batch transaction detail', e, stackTrace);
      emit(BatchTransactionDetailError(e.message));
    } on UnexpectedException catch (e, stackTrace) {
      _log.severe(
        'Unexpected error fetching batch transaction detail',
        e,
        stackTrace,
      );
      emit(BatchTransactionDetailError(e.message));
    } catch (e, stackTrace) {
      _log.severe(
        'Unhandled error fetching batch transaction detail',
        e,
        stackTrace,
      );
      if (kDebugMode) {
        emit(BatchTransactionDetailError('Ada kendala: ${e.toString()}'));
      } else {
        emit(BatchTransactionDetailError(AppMessages.unknownError));
      }
    }
  }
}
