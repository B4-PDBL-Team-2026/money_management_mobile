import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/get_fixed_cost_occurrences_usecase.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/fixed_cost_occurrences_state.dart';

class FixedCostOccurrencesCubit extends Cubit<FixedCostOccurrencesState> {
  final GetFixedCostOccurrencesUseCase getFixedCostOccurrencesUseCase;
  final _log = Logger('FixedCostOccurrencesCubit');

  FixedCostOccurrencesCubit(this.getFixedCostOccurrencesUseCase)
    : super(FixedCostOccurrencesInitial());

  Future<void> fetchFixedCostOccurrences({bool forceRefresh = false}) async {
    if (!forceRefresh && state is FixedCostOccurrencesSuccess) {
      return;
    }

    emit(FixedCostOccurrencesLoading());

    try {
      final items = await getFixedCostOccurrencesUseCase.execute();
      emit(FixedCostOccurrencesSuccess(items));
    } on ServerException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } on NetworkException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } on UnauthorizedException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } on UnexpectedException catch (e) {
      emit(FixedCostOccurrencesError(e.message));
    } catch (e) {
      _log.severe('Unexpected error while fetching fixed cost occurrences', e);
      emit(FixedCostOccurrencesError('Terjadi kesalahan: ${e.toString()}'));
    }
  }
}
