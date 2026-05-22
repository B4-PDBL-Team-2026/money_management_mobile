import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';

/// Class internal untuk menyimpan data API Key beserta waktu cooldown-nya di memori
class ApiKeyData {
  final String key;
  DateTime? limitUntil;

  ApiKeyData({required this.key});

  /// Mengembalikan true jika key siap digunakan (tidak ada cooldown atau sudah lewat masa cooldown)
  bool get isAvailable {
    if (limitUntil == null) return true;
    return DateTime.now().isAfter(limitUntil!);
  }
}

@LazySingleton()
class GeminiScannerService {
  final Logger _log = Logger('GeminiScannerService');

  /// Dio khusus untuk Gemini — bersih tanpa interceptor auth backend.
  /// Dibuat sendiri agar tidak terkontaminasi Bearer token dari backend API.
  late final Dio _dio;

  final List<ApiKeyData> _apiKeys = [];

  GeminiScannerService() {
    // Buat Dio baru yang bersih, hanya untuk Gemini API
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
      ),
    );

    final rawKeys = AppEnv.geminiApiKeys;

    if (rawKeys.isEmpty) {
      _log.warning(
        "Tidak ada API Key Gemini yang dikonfigurasi. Pastikan variabel lingkungan GEMINI_API_KEYS sudah di-set.",
      );
    }

    for (final key in rawKeys.split(',')) {
      final trimmed = key.trim();
      if (trimmed.isNotEmpty) {
        _apiKeys.add(ApiKeyData(key: trimmed));
      }
    }
  }

  /// Fungsi utama yang akan dipanggil untuk scan struk
  /// Mengembalikan String hasil response dari Gemini.
  Future<String> scanReceipt(File imageFile, String prompt) async {
    int attempts = 0;

    // Coba secara bergilir jika ada yang terkena limit
    while (attempts < _apiKeys.length) {
      final apiKeyData = _getAvailableKey();

      if (apiKeyData == null) {
        throw Exception(
          "Semua API Key Gemini saat ini sedang limit/cooldown. Silakan coba beberapa saat lagi.",
        );
      }

      try {
        _log.info(
          'Gemini Scanner: Menggunakan API Key ${apiKeyData.key.substring(0, 8)}...',
        );

        final resultText = await _processImageWithGemini(
          file: imageFile,
          prompt: prompt,
          apiKey: apiKeyData.key,
        );

        return resultText;
      } on DioException catch (e) {
        final statusCode = e.response?.statusCode;
        // Google API biasanya membalas pesan detail quota di body response
        final responseBody = e.response?.data?.toString().toLowerCase() ?? '';

        // Tangkap kode 429 (Too Many Requests) atau pesan yang mengandung kata "quota"
        if (statusCode == 429 || responseBody.contains('quota')) {
          // Logika pembeda RPD vs RPM
          // Jika pesan limit menyebutkan 'day' atau 'daily', berarti limit harian (RPD).
          if (responseBody.contains('day') || responseBody.contains('daily')) {
            _log.info(
              "Gemini Scanner: Terkena limit HARIAN (RPD). Key di-pause 24 jam.",
            );
            apiKeyData.limitUntil = DateTime.now().add(
              const Duration(hours: 24),
            );
          } else {
            // Jika tidak, asumsikan limit per menit (RPM).
            _log.info(
              "Gemini Scanner: Terkena limit MENITAN (RPM). Key di-pause 1 menit.",
            );
            apiKeyData.limitUntil = DateTime.now().add(
              const Duration(minutes: 1),
            );
          }

          attempts++;
          continue; // Lanjut ke iterasi while berikutnya (coba key lain)
        } else {
          // Jika error selain dari limit (misalnya: 400 Bad Request, Koneksi Terputus)
          throw Exception("Gagal memanggil Gemini API: ${e.message}");
        }
      } catch (e) {
        // Exception umum (misalnya gagal convert Base64, dll)
        throw Exception("Terjadi kesalahan sistem: $e");
      }
    }

    throw Exception(
      "Proses gagal. Semua API key telah dicoba dan semuanya sedang terkena rate limit.",
    );
  }

  /// Memanggil REST API Gemini secara langsung menggunakan Dio
  Future<String> _processImageWithGemini({
    required File file,
    required String prompt,
    required String apiKey,
  }) async {
    // 1. Encode file gambar ke Base64
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);

    // 2. Deteksi Mime Type sederhana dari ekstensi file
    String mimeType = 'image/jpeg';
    final pathLower = file.path.toLowerCase();
    if (pathLower.endsWith('.png')) {
      mimeType = 'image/png';
    } else if (pathLower.endsWith('.webp')) {
      mimeType = 'image/webp';
    } else if (pathLower.endsWith('.heic')) {
      mimeType = 'image/heic';
    }

    // 3. Endpoint Gemini 3.1 Flash Lite
    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite:generateContent';

    // 4. Struktur Payload JSON sesuai dokumentasi Gemini REST API
    final payload = {
      "contents": [
        {
          "parts": [
            {
              "text": prompt, // Prompt instruksi dari Anda
            },
            {
              "inlineData": {"mimeType": mimeType, "data": base64Image},
            },
          ],
        },
      ],
      // [OPSIONAL] Jika nanti Anda ingin memaksa Gemini mengeluarkan output format JSON murni
      // Anda bisa membuka komen di bawah ini:
      /*
      "generationConfig": {
         "responseMimeType": "application/json",
      }
      */
    };

    // 5. Eksekusi request POST
    final response = await _dio.post(
      url,
      data: payload,
      options: Options(
        headers: {'Content-Type': 'application/json', 'x-goog-api-key': apiKey},
      ),
    );

    // 6. Parsing Output
    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = response.data;
        // Posisi standar hasil text di JSON Gemini API
        final textResult =
            responseData['candidates'][0]['content']['parts'][0]['text'];
        return textResult as String;
      } catch (e) {
        throw Exception(
          "Gagal mengekstrak teks dari respons Gemini. Struktur JSON mungkin berubah.",
        );
      }
    } else {
      throw Exception("Respon API tidak sukses: HTTP ${response.statusCode}");
    }
  }

  /// Mencari API Key pertama yang `limitUntil`-nya sudah lewat atau `null`
  ApiKeyData? _getAvailableKey() {
    for (var keyData in _apiKeys) {
      if (keyData.isAvailable) {
        return keyData;
      }
    }
    return null; // Return null jika semua key masih dalam masa cooldown
  }
}
