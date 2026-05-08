import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:money_management_mobile/core/error/execeptions.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/voice_transaction_state.dart';
import 'package:money_management_mobile/features/transaction/domain/usecases/parse_voice_transaction_usecase.dart';
import 'package:event_bus/event_bus.dart';
import 'package:money_management_mobile/core/events/app_events.dart';

@Injectable()
class VoiceTransactionCubit extends Cubit<VoiceTransactionState> {
  final TransactionRepository _transactionRepository;
  final EventBus _eventBus;
  final _log = Logger('VoiceTransactionCubit');

  final stt.SpeechToText _speech = stt.SpeechToText();
  Timer? _elapsedTimer;
  Duration _elapsed = Duration.zero;
  bool _speechInitialized = false;

  VoiceTransactionCubit(this._transactionRepository, this._eventBus)
      : super(VoiceTransactionInitial());

  // ── Speech ───────────────────────────────────────────────────────────────────

  Future<bool> _initSpeech() async {
    if (_speechInitialized) return true;
    _speechInitialized = await _speech.initialize(
      onError: (error) {
        _log.warning('Speech error: ${error.errorMsg}');
        if (!isClosed) stopListening();
      },
    );
    return _speechInitialized;
  }

  Future<void> startListening() async {
    final available = await _initSpeech();
    if (!available) {
      emit(VoiceTransactionError(
          message: 'Mikrofon tidak tersedia di perangkat ini.'));
      return;
    }

    _elapsed = Duration.zero;
    emit(VoiceTransactionListening(transcript: '', elapsed: _elapsed));

    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed += const Duration(seconds: 1);
      final current = state;
      if (current is VoiceTransactionListening) {
        emit(VoiceTransactionListening(
          transcript: current.transcript,
          elapsed: _elapsed,
        ));
      }
    });

    await _speech.listen(
      onResult: (result) {
        if (!isClosed && state is VoiceTransactionListening) {
          emit(VoiceTransactionListening(
            transcript: result.recognizedWords,
            elapsed: _elapsed,
          ));
        }
      },
      localeId: 'id_ID',
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 4),
    );
  }

  Future<void> stopListening() async {
    _elapsedTimer?.cancel();
    _elapsedTimer = null;

    final current = state;
    String transcript = '';
    if (current is VoiceTransactionListening) {
      transcript = current.transcript;
    }

    await _speech.stop();

    if (transcript.trim().isEmpty) {
      emit(VoiceTransactionInitial());
      return;
    }

    _parseTranscript(transcript);
  }

  // ── Text input ────────────────────────────────────────────────────────────────

  void submitTextInput(String text) {
    if (text.trim().isEmpty) return;
    _parseTranscript(text.trim());
  }

  // ── Parse ─────────────────────────────────────────────────────────────────────

  void _parseTranscript(String transcript) {
    emit(VoiceTransactionParsing(transcript: transcript));

    final parsed = TransactionInputParser.parse(transcript);
    if (parsed == null) {
      emit(VoiceTransactionParseError(rawInput: transcript));
    } else {
      emit(VoiceTransactionParsed(parsedData: parsed));
    }
  }

  // Category override
  //
  // Called from the page when the user picks a different category from the
  // CategoryBottomSheet on the parsed-preview screen. We emit a new
  // VoiceTransactionParsed with the updated data, then immediately save.

  void overrideParsedData(ParsedTransactionData updated) {
    emit(VoiceTransactionParsed(parsedData: updated));
    // Save right away — the user already confirmed by tapping "Simpan"
    saveTransaction();
  }

  // Save

  Future<void> saveTransaction() async {
    final current = state;
    if (current is! VoiceTransactionParsed) return;

    final data = current.parsedData;
    emit(VoiceTransactionSubmitting(parsedData: data));

    try {
      final transaction = await _transactionRepository.addTransaction(
        TransactionEntity(
          name: data.name,
          amount: data.amount,
          type: data.type,
          categoryId: data.categoryId,
          transactionAt: data.transactionAt,
          note: data.note,
        ),
      );

      _eventBus.fire(const TransactionChangesEvent());
      emit(VoiceTransactionSuccess(transaction: transaction));
    } on ServerException catch (e) {
      emit(VoiceTransactionError(message: e.message));
    } on NetworkException catch (e) {
      emit(VoiceTransactionError(message: e.message));
    } on ValidationException catch (e) {
      emit(VoiceTransactionError(
          message:
          e.fieldErrors?.values.first?.toString() ?? 'Validasi gagal'));
    } on UnexpectedException catch (e) {
      emit(VoiceTransactionError(message: e.message));
    } catch (e) {
      _log.severe('Unexpected error saving voice transaction', e);
      emit(VoiceTransactionError(
        message: kDebugMode
            ? 'Error: ${e.toString()}'
            : 'Terjadi kesalahan. Silakan coba lagi.',
      ));
    }
  }

  // Reset

  void reset() {
    _elapsedTimer?.cancel();
    _speech.stop();
    emit(VoiceTransactionInitial());
  }

  @override
  Future<void> close() {
    _elapsedTimer?.cancel();
    _speech.stop();
    return super.close();
  }
}