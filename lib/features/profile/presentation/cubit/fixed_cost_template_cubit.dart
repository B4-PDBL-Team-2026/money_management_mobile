import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_template_entity.dart';
import 'package:money_management_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/fixed_cost_template_state.dart';
import 'package:event_bus/event_bus.dart';

@LazySingleton()
class FixedCostTemplateCubit extends Cubit<FixedCostTemplateState> {
  final ProfileRepository _profileRepository;
  final EventBus _eventBus;
  late final StreamSubscription<dynamic> _refreshSubscription;

  final _log = Logger('FixedCostTemplateCubit');

  FixedCostTemplateCubit(this._profileRepository, this._eventBus)
    : super(FixedCostTemplateInitial()) {
    _refreshSubscription = _eventBus.on<FixedCostTemplateChangesEvent>().listen(
      (_) => fetchFixedCostTemplate(forceRefresh: true),
    );
  }

  Future<void> fetchFixedCostTemplate({bool forceRefresh = false}) async {
    if (!forceRefresh && state is FixedCostTemplateSuccess) {
      return;
    }

    emit(FixedCostTemplateLoading());

    try {
      final items = await _profileRepository.getFixedCostTemplate();
      emit(FixedCostTemplateSuccess(items));
    } on ServerException catch (e) {
      emit(FixedCostTemplateError(e.message));
    } on NetworkException catch (e) {
      emit(FixedCostTemplateError(e.message));
    } on UnauthorizedException catch (e) {
      emit(FixedCostTemplateError(e.message));
    } on UnexpectedException catch (e) {
      emit(FixedCostTemplateError(e.message));
    } catch (e) {
      _log.severe('Unexpected error while fetching fixed cost occurrences', e);
      emit(FixedCostTemplateError('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  Future<void> createFixedCost(FixedCostTemplateEntity payload) async {
    emit(FixedCostTemplateLoading());

    try {
      await _profileRepository.createFixedCost(payload);
      await fetchFixedCostTemplate(forceRefresh: true);
      _eventBus.fire(const FixedCostTemplateChangesEvent());
      _eventBus.fire(const FixedCostOccurrencesChangesEvent());
    } on ServerException catch (e) {
      emit(FixedCostTemplateError(e.message));
    } on NetworkException catch (e) {
      emit(FixedCostTemplateError(e.message));
    } on UnauthorizedException catch (e) {
      emit(FixedCostTemplateError(e.message));
    } on ValidationException catch (e) {
      emit(FixedCostTemplateError(e.toString()));
    } on UnexpectedException catch (e) {
      emit(FixedCostTemplateError(e.message));
    } catch (e) {
      _log.severe('Unexpected error while creating fixed cost', e);
      emit(FixedCostTemplateError('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  Future<void> deleteFixedCost(int fixedCostTemplateId) async {
    emit(FixedCostTemplateLoading());

    try {
      await _profileRepository.deleteFixedCost(fixedCostTemplateId);
      await fetchFixedCostTemplate(forceRefresh: true);
      _eventBus.fire(const FixedCostTemplateChangesEvent());
      _eventBus.fire(const FixedCostOccurrencesChangesEvent());
    } on ServerException catch (e) {
      emit(FixedCostTemplateError(e.message));
    } on NetworkException catch (e) {
      emit(FixedCostTemplateError(e.message));
    } on UnauthorizedException catch (e) {
      emit(FixedCostTemplateError(e.message));
    } on ValidationException catch (e) {
      emit(FixedCostTemplateError(e.toString()));
    } on UnexpectedException catch (e) {
      emit(FixedCostTemplateError(e.message));
    } catch (e) {
      _log.severe('Unexpected error while deleting fixed cost', e);
      emit(FixedCostTemplateError('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  Future<void> updateFixedCost(
    int fixedCostTemplateId,
    FixedCostTemplateEntity payload,
  ) async {
    emit(FixedCostTemplateLoading());

    try {
      await _profileRepository.updateFixedCost(fixedCostTemplateId, payload);
      await fetchFixedCostTemplate(forceRefresh: true);
      _eventBus.fire(const FixedCostTemplateChangesEvent());
      _eventBus.fire(const FixedCostOccurrencesChangesEvent());
    } on ServerException catch (e) {
      emit(FixedCostTemplateError(e.message));
    } on NetworkException catch (e) {
      emit(FixedCostTemplateError(e.message));
    } on UnauthorizedException catch (e) {
      emit(FixedCostTemplateError(e.message));
    } on ValidationException catch (e) {
      emit(FixedCostTemplateError(e.toString()));
    } on UnexpectedException catch (e) {
      emit(FixedCostTemplateError(e.message));
    } catch (e) {
      _log.severe('Unexpected error while updating fixed cost', e);
      emit(FixedCostTemplateError('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _refreshSubscription.cancel();
    return super.close();
  }
}
