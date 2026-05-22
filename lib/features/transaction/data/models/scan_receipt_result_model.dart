import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

/// Model untuk satu item transaksi dalam output JSON Gemini.
///
/// Struktur JSON yang diharapkan dari Gemini per item:
/// ```json
/// {
///   "name": "...",
///   "amount": 1,
///   "categoryId": 1,
///   "type": "income | expense",
///   "note": null
/// }
/// ```
class ScanReceiptItemModel {
  final String name;
  final int amount;
  final int categoryId;
  final TransactionType type;
  final String? note;

  const ScanReceiptItemModel({
    required this.name,
    required this.amount,
    required this.categoryId,
    required this.type,
    this.note,
  });

  factory ScanReceiptItemModel.fromJson(Map<String, dynamic> json) {
    return ScanReceiptItemModel(
      name: json['name'] as String? ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      categoryId: (json['categoryId'] as num?)?.toInt() ?? 0,
      type:
          TransactionType.fromValue(json['type'] as String?) ??
          TransactionType.expense,
      note: json['note'] as String?,
    );
  }
}

/// Model utama untuk seluruh output JSON dari Gemini saat scan struk.
///
/// Struktur JSON yang diharapkan dari Gemini:
/// ```json
/// {
///   "name": "...",
///   "transactionAt": "2025-05-22",
///   "note": null,
///   "source": "batch",
///   "items": [ ... ]
/// }
/// ```
///
/// Jika output mengandung `{ "error": "..." }`, gunakan [ScanReceiptResultModel.isError]
/// dan lempar [InvalidReceiptException] sesuai pesan error-nya.
class ScanReceiptResultModel {
  final String? name;
  final String? transactionAt;
  final String? note;
  final String? source;
  final List<ScanReceiptItemModel> items;

  /// Berisi pesan error dari Gemini jika gambar tidak valid.
  final String? error;

  bool get isError => error != null && error!.isNotEmpty;

  const ScanReceiptResultModel({
    this.name,
    this.transactionAt,
    this.note,
    this.source,
    this.items = const [],
    this.error,
  });

  factory ScanReceiptResultModel.fromJson(Map<String, dynamic> json) {
    // Cek apakah output berisi field error dari Gemini
    if (json.containsKey('error')) {
      return ScanReceiptResultModel(error: json['error'] as String?);
    }

    final rawItems = json['items'] as List<dynamic>? ?? [];
    final items =
        rawItems
            .whereType<Map<String, dynamic>>()
            .map(ScanReceiptItemModel.fromJson)
            .toList();

    return ScanReceiptResultModel(
      name: json['name'] as String?,
      transactionAt: json['transactionAt'] as String?,
      note: json['note'] as String?,
      source: json['source'] as String?,
      items: items,
    );
  }
}
