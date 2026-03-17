import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/usecases/add_transaction_usecase.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/add_transaction_state.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  final AddTransactionUseCase addTransactionUseCase;
  final _log = Logger('AddTransactionCubit');

  AddTransactionCubit(this.addTransactionUseCase)
      : super(AddTransactionInitial());

  Future<void> addTransaction({
    required String name,
    required int amount,
    required TransactionKind type,
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

      _log.info('Add transaction completed: ${transaction.id}');
      emit(AddTransactionSuccess(transaction));
    } on ServerException catch (e) {
      _log.severe('Add transaction failed with ServerException', e);
      emit(AddTransactionError(e.message));
    } on NetworkException catch (e) {
      _log.warning('Add transaction failed with NetworkException', e);
      emit(AddTransactionError(e.message));
    } on UnexpectedException catch (e) {
      _log.severe('Add transaction failed with UnexpectedException', e);
      emit(AddTransactionError(e.message));
    } catch (e) {
      _log.severe('Add transaction failed with unknown error', e);
      emit(AddTransactionError('Terjadi kesalahan: ${e.toString()}'));
    }
  }
}
