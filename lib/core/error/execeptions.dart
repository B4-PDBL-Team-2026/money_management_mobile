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
  final String message;
  ValidationException([this.message = "Data yang diberikan tidak valid"]);

  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = "Akses tidak sah"]);

  @override
  String toString() => message;
}
