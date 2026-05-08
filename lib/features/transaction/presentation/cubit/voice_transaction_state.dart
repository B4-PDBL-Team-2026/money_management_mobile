import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

sealed class VoiceTransactionState {}

final class VoiceTransactionInitial extends VoiceTransactionState {}

final class VoiceTransactionListening extends VoiceTransactionState {
  final String transcript;
  final Duration elapsed;

  VoiceTransactionListening({
    required this.transcript,
    required this.elapsed,
  });
}

final class VoiceTransactionParsing extends VoiceTransactionState {
  final String transcript;

  VoiceTransactionParsing({required this.transcript});
}

final class VoiceTransactionParsed extends VoiceTransactionState {
  final ParsedTransactionData parsedData;

  VoiceTransactionParsed({required this.parsedData});
}

final class VoiceTransactionParseError extends VoiceTransactionState {
  final String rawInput;

  VoiceTransactionParseError({required this.rawInput});
}

final class VoiceTransactionSubmitting extends VoiceTransactionState {
  final ParsedTransactionData parsedData;

  VoiceTransactionSubmitting({required this.parsedData});
}

final class VoiceTransactionSuccess extends VoiceTransactionState {
  final TransactionEntity transaction;

  VoiceTransactionSuccess({required this.transaction});
}

final class VoiceTransactionError extends VoiceTransactionState {
  final String message;

  VoiceTransactionError({required this.message});
}

class ParsedTransactionData {
  final int amount;
  final TransactionType type;
  final String name;
  final String categoryName;
  final int categoryId;
  final DateTime transactionAt;
  final String? note;

  ParsedTransactionData({
    required this.amount,
    required this.type,
    required this.name,
    required this.categoryName,
    required this.categoryId,
    required this.transactionAt,
    this.note,
  });
}