class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = "Koneksi internet bermasalah"]);

  @override
  String toString() => message;
}

class UnexpectedException implements Exception {
  final String message;
  UnexpectedException([this.message = "Terjadi kesalahan yang tidak terduga"]);

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  /// Optional map of field errors, where the key is the field name and the value is the error message for that field.
  final String message;
  final Map<String, dynamic>? fieldErrors;

  ValidationException([
    this.fieldErrors,
    this.message = "Data yang diberikan tidak valid",
  ]);

  @override
  String toString() => message;
}

class CacheNotFoundException implements Exception {
  final String message;
  CacheNotFoundException([this.message = "Data tidak ditemukan di cache"]);

  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = "Data tidak ditemukan"]);

  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = "Akses tidak sah"]);

  @override
  String toString() => message;
}
