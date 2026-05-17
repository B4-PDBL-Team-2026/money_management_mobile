import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/add_batch_transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/batch_transaction_submit_state.dart';

@Injectable()
class BatchTransactionSubmitCubit extends Cubit<BatchTransactionSubmitState> {
  final TransactionRepository _transactionRepository;
  final EventBus _eventBus;

  final _log = Logger('BatchTransactionSubmitCubit');

  BatchTransactionSubmitCubit(this._transactionRepository, this._eventBus)
    : super(BatchTransactionSubmitInitial());

  Future<void> submit({
    required AddBatchTransactionEntity addBatchTransaction,
  }) async {
    if (addBatchTransaction.items.isEmpty) return;

    emit(BatchTransactionSubmitLoading());

    try {
      // for (final item in addBatchTransaction.items) {
      //   await _transactionRepository.addTransaction(
      //     TransactionEntity(
      //       name: '${addBatchTransaction.name.trim()} > ${item.name}',
      //       amount: item.amount,
      //       type: item.type,
      //       categoryId: item.categoryId,
      //       transactionAt: addBatchTransaction.transactionAt,
      //       note: addBatchTransaction.note,
      //     ),
      //   );
      // }

      _eventBus.fire(const TransactionChangesEvent());
      emit(BatchTransactionSubmitSuccess());
    } on ServerException catch (e) {
      _log.severe('Server error while submitting batch transaction', e);
      emit(BatchTransactionSubmitError(e.message));
    } on NetworkException catch (e) {
      _log.severe('Network error while submitting batch transaction', e);
      emit(BatchTransactionSubmitError(e.message));
    } on ValidationException catch (e) {
      _log.severe('Validation error while submitting batch transaction', e);
      emit(BatchTransactionSubmitValidationError(e.fieldErrors));
    } on UnexpectedException catch (e) {
      _log.severe('Unexpected error while submitting batch transaction', e);
      emit(BatchTransactionSubmitError(e.message));
    } catch (e) {
      _log.severe('Unhandled error while submitting batch transaction', e);
      if (kDebugMode) {
        emit(BatchTransactionSubmitError('Terjadi kesalahan: ${e.toString()}'));
      } else {
        emit(
          BatchTransactionSubmitError(
            'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
    }
  }

  void reset() => emit(BatchTransactionSubmitInitial());
}
