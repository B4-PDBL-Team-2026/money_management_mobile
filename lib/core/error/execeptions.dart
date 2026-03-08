/// Exception yang dilempar saat terjadi error di sisi Server/API
class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => message;
}

/// Exception untuk masalah koneksi internet atau timeout
class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = "Koneksi internet bermasalah"]);

  @override
  String toString() => message;
}

/// Exception untuk masalah yang tidak terduga, seperti error parsing data atau error lainnya yang tidak spesifik
class UnexpectedException implements Exception {
  final String message;
  UnexpectedException([this.message = "Terjadi kesalahan yang tidak terduga"]);

  @override
  String toString() => message;
}
