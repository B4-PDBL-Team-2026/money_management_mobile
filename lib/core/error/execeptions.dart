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
  final Map<String, dynamic>? fieldErrors;
  ValidationException([this.fieldErrors]);

  @override
  String toString() => "Data yang diberikan tidak valid";
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
