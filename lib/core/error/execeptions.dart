import 'package:money_management_mobile/core/constants/app_messages.dart';

class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = AppMessages.internetProblem]);

  @override
  String toString() => message;
}

class UnexpectedException implements Exception {
  final String message;
  UnexpectedException([this.message = AppMessages.unknownError]);

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  /// Optional map of field errors, where the key is the field name and the value is the error message for that field.
  final String message;
  final Map<String, dynamic>? fieldErrors;

  ValidationException([
    this.fieldErrors,
    this.message = AppMessages.dataInvalid,
  ]);

  @override
  String toString() => message;
}

class CacheNotFoundException implements Exception {
  final String message;
  CacheNotFoundException([this.message = AppMessages.cacheNotFound]);

  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = AppMessages.dataNotFound]);

  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = AppMessages.unauthorized]);

  @override
  String toString() => message;
}
