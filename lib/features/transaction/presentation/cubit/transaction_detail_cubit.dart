import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:event_bus/event_bus.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_detail_state.dart';

@Injectable()
class TransactionDetailCubit extends Cubit<TransactionDetailState> {
  final TransactionRepository _transactionRepository;
  final EventBus _eventBus;

  final _log = Logger('TransactionDetailCubit');

  TransactionDetailCubit(this._transactionRepository, this._eventBus)
    : super(TransactionDetailInitial());

  Future<void> getTransactionDetail({required int id}) async {
    _log.info('Fetch transaction detail started for transaction id: $id');
    emit(TransactionDetailLoading());

    try {
      final result = await _transactionRepository.getTransactionDetail(id: id);
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

  Future<bool> updateTransaction({
    required int id,
    required String name,
    required int amount,
    required TransactionType type,
    required int categoryId,
    required RealCategoryType categoryType,
    required DateTime transactionAt,
    String? note,
  }) async {
    _log.info('Update transaction started for transaction id: $id');

    try {
      await _transactionRepository.updateTransaction(
        id: id,
        name: name,
        amount: amount,
        type: type,
        categoryId: categoryId,
        categoryType: categoryType,
        transactionAt: transactionAt,
        note: note,
      );

      _eventBus.fire(const TransactionChangesEvent());
      await getTransactionDetail(id: id);
      return true;
    } on ServerException catch (e) {
      _log.severe('Server error while updating transaction detail', e);
      emit(TransactionDetailError(e.message));
      return false;
    } on NetworkException catch (e) {
      _log.severe('Network error while updating transaction detail', e);
      emit(TransactionDetailError(e.message));
      return false;
    } on UnexpectedException catch (e) {
      _log.severe('Unexpected error while updating transaction detail', e);
      emit(TransactionDetailError(e.message));
      return false;
    } on BusinessRuleException catch (e) {
      _log.severe('[BusinessRuleException]', e.message);
      emit(TransactionDetailError(e.message));
      return false;
    } catch (e) {
      _log.severe('Unhandled error while updating transaction detail', e);
      if (kDebugMode) {
        emit(TransactionDetailError('Terjadi kesalahan: ${e.toString()}'));
      } else {
        emit(
          TransactionDetailError(
            'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
      return false;
    }
  }

  Future<bool> deleteTransaction({required int id}) async {
    _log.info('Delete transaction started for transaction id: $id');
    emit(TransactionDetailLoading());

    try {
      await _transactionRepository.deleteTransaction(id: id);
      _eventBus.fire(const TransactionChangesEvent());
      emit(TransactionDetailDeleted('Transaksi berhasil dihapus.'));
      return true;
    } on ServerException catch (e) {
      _log.severe('Server error while deleting transaction detail', e);
      emit(TransactionDetailError(e.message));
      return false;
    } on NetworkException catch (e) {
      _log.severe('Network error while deleting transaction detail', e);
      emit(TransactionDetailError(e.message));
      return false;
    } on UnexpectedException catch (e) {
      _log.severe('Unexpected error while deleting transaction detail', e);
      emit(TransactionDetailError(e.message));
      return false;
    }  on BusinessRuleException catch (e) {
      _log.severe('[BusinessRuleException]', e.message);
      emit(TransactionDetailError(e.message));
      return false;
    } catch (e) {
      _log.severe('Unhandled error while deleting transaction detail', e);
      if (kDebugMode) {
        emit(TransactionDetailError('Terjadi kesalahan: ${e.toString()}'));
      } else {
        emit(
          TransactionDetailError(
            'Terjadi kesalahan yang tidak terduga. Silakan coba lagi nanti.',
          ),
        );
      }
      return false;
    }
  }
}
