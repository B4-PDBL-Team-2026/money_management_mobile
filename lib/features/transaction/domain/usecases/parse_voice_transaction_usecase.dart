import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/voice_transaction_state.dart';

/// Parses natural language Indonesian transaction input into structured data.
///
/// Supported input examples:
///   "Beli nasi padang seharga 25rb hari ini"
///   "Dapat gaji seharga 5jt kemarin"
///   "Bayar listrik 150000 tadi"
///   "Beli soto ayam seharga Rp25.000 hari ini"   ← Rp prefix + dot separator
///   "Beli kopi di Kenangan seharga 35.000"
///   "Transfer 1.500.000 kemarin"
class TransactionInputParser {
  // ── Normalization ─────────────────────────────────────────────────────────

  /// Produces a clean lowercase string ready for regex matching:
  ///   1. Lowercase
  ///   2. Strip "Rp" / "rp" currency prefix (with optional dot/space after)
  ///   3. Collapse Indonesian thousand-separator dots:
  ///      "25.000" → "25000",  "1.500.000" → "1500000"
  ///   4. Normalize decimal commas to dots for double parsing later
  static String _normalize(String text) {
    String s = text.toLowerCase().trim();

    // Removing Rp prefix ("Rp25.000", "rp 25.000", "Rp. 25.000")
    s = s.replaceAll(RegExp(r'rp\.?\s*'), '');

    // Collapsing thousand-separator dots
    // Pattern: digit followed by dot followed by exactly 3 digits,
    // where after those 3 digits comes another digit, dot, suffix, space, or end.
    // Run twice to handle "1.500.000" (two separators).
    for (int i = 0; i < 3; i++) {
      s = s.replaceAllMapped(
        RegExp(r'(\d)\.(\d{3})(?=\d|\.|\s|(?:rb|ribu|jt|juta|k)\b|$)'),
            (m) => '${m[1]}${m[2]}',
      );
    }

    // Normalizing decimal comma → dot  ("1,5jt" → "1.5jt")
    s = s.replaceAllMapped(
      RegExp(r'(\d),(\d)'),
          (m) => '${m[1]}.${m[2]}',
    );

    return s;
  }

  // Amount parsing
  static int? parseAmount(String text) {
    final s = _normalize(text);

    // Priority: juta → ribu → plain integer
    final patterns = <(RegExp, int)>[
      (RegExp(r'(\d+(?:\.\d+)?)\s*(?:jt|juta)\b'), 1000000),
      (RegExp(r'(\d+(?:\.\d+)?)\s*(?:rb|ribu|k)\b'), 1000),
      // Plain integer ≥ 3 digits, not immediately preceded by a letter
      (RegExp(r'(?<![a-z])(\d{3,})(?![a-z])'), 1),
    ];

    for (final (pattern, multiplier) in patterns) {
      final match = pattern.firstMatch(s);
      if (match != null) {
        final num = double.tryParse(match.group(1)!);
        if (num != null && num > 0) return (num * multiplier).round();
      }
    }
    return null;
  }

  // Transaction type

  static TransactionType parseType(String text) {
    final lower = text.toLowerCase();
    const incomeKeywords = [
      'dapat', 'dapet', 'terima', 'gaji', 'bonus', 'transfer masuk',
      'income', 'pemasukan', 'untung', 'profit', 'dividen',
      'pinjaman cair', 'cairkan', 'jual', 'hasil', 'pendapatan',
    ];
    for (final kw in incomeKeywords) {
      if (lower.contains(kw)) return TransactionType.income;
    }
    return TransactionType.expense;
  }

  // Date parsing

  static DateTime parseDate(String text) {
    final lower = text.toLowerCase();
    final today = DateTime.now();
    final d = DateTime(today.year, today.month, today.day);
    if (lower.contains('kemarin') || lower.contains('yesterday')) {
      return d.subtract(const Duration(days: 1));
    }
    if (lower.contains('lusa')) return d.add(const Duration(days: 2));
    if (lower.contains('besok') || lower.contains('tomorrow')) {
      return d.add(const Duration(days: 1));
    }
    return d;
  }

  // Transaction name

  static String parseName(String raw) {
    String s = raw;
    // Strip Rp+amount
    s = s.replaceAll(RegExp(r'Rp\.?\s*[\d.,]+', caseSensitive: false), '');
    // Strip shorthand amounts
    s = s.replaceAll(
      RegExp(r'\d+(?:[.,]\d+)?\s*(?:jt|juta|rb|ribu|k\b)', caseSensitive: false),
      '',
    );
    // Strip bare numbers ≥ 3 digits
    s = s.replaceAll(RegExp(r'\b\d{3,}\b'), '');
    // Strip filler keywords
    s = s.replaceAll(
      RegExp(r'\b(?:seharga|harga|senilai|sebesar|sejumlah)\b', caseSensitive: false),
      '',
    );
    s = s.replaceAll(
      RegExp(r'\b(?:hari ini|kemarin|lusa|tadi|besok|today|yesterday)\b', caseSensitive: false),
      '',
    );
    s = s.replaceAll(
      RegExp(r'\b(?:di|ke|dari|pada|untuk)\b', caseSensitive: false),
      ' ',
    );
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (s.isEmpty) return raw;
    return s[0].toUpperCase() + s.substring(1);
  }

  // Category inference

  static ({String name, int id}) inferCategory(String text, TransactionType type) {
    final lower = text.toLowerCase();

    if (type == TransactionType.income) {
      if (_any(lower, ['gaji', 'salary', 'upah'])) return (name: 'Pendapatan', id: 11);
      if (_any(lower, ['bonus'])) return (name: 'Bonus', id: 12);
      if (_any(lower, ['hadiah', 'gift'])) return (name: 'Hadiah', id: 13);
      if (_any(lower, ['dividen', 'saham', 'investasi'])) return (name: 'Investasi', id: 14);
      if (_any(lower, ['pinjaman', 'utang', 'hutang'])) return (name: 'Pinjaman', id: 15);
      return (name: 'Pemasukan Lainnya', id: 16);
    }

    if (_any(lower, ['makan', 'minum', 'kopi', 'nasi', 'bakso', 'soto', 'ayam', 'mie',
      'resto', 'warung', 'cafe', 'food', 'lunch', 'dinner', 'breakfast', 'snack',
      'jajan', 'burger', 'pizza', 'martabak', 'es', 'minuman'])) {
      return (name: 'Makanan & Minuman', id: 1);
    }
    if (_any(lower, ['ojek', 'grab', 'gojek', 'taxi', 'bensin', 'bbm', 'parkir',
      'toll', 'tol', 'transport', 'busway', 'mrt', 'lrt', 'kereta', 'bus', 'angkot'])) {
      return (name: 'Transportasi', id: 2);
    }
    if (_any(lower, ['listrik', 'wifi', 'internet', 'pulsa', 'token', 'pdam', 'air',
      'gas', 'tagihan', 'langganan', 'subscription', 'netflix', 'spotify'])) {
      return (name: 'Tagihan & Utilitas', id: 3);
    }
    if (_any(lower, ['belanja', 'baju', 'sepatu', 'fashion', 'pakaian', 'tas'])) {
      return (name: 'Belanja', id: 4);
    }
    if (_any(lower, ['bioskop', 'hiburan', 'nonton', 'tiket', 'game', 'entertainment',
      'konser', 'wisata'])) {
      return (name: 'Hiburan', id: 5);
    }
    if (_any(lower, ['supermarket', 'indomaret', 'alfamart', 'kebutuhan', 'groceries',
      'sembako', 'deterjen', 'sabun'])) {
      return (name: 'Kebutuhan Rumah', id: 6);
    }
    if (_any(lower, ['obat', 'dokter', 'rumah sakit', 'klinik', 'apotek', 'kesehatan',
      'medical', 'health', 'vitamin'])) {
      return (name: 'Kesehatan', id: 7);
    }
    if (_any(lower, ['donasi', 'sedekah', 'infaq', 'zakat', 'charity', 'amal', 'panti'])) {
      return (name: 'Donasi & Amal', id: 8);
    }
    if (_any(lower, ['pendidikan', 'sekolah', 'kuliah', 'kursus', 'buku', 'education',
      'les', 'pelatihan'])) {
      return (name: 'Pendidikan', id: 9);
    }
    return (name: 'Lainnya', id: 10);
  }

  static bool _any(String text, List<String> keywords) =>
      keywords.any((kw) => text.contains(kw));

  static String _titleCase(String s) => s
      .split(' ')
      .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1).toLowerCase())
      .join(' ');

  // Main entry

  static ParsedTransactionData? parse(String input) {
    final amount = parseAmount(input);
    if (amount == null || amount <= 0) return null;

    final type = parseType(input);
    final transactionAt = parseDate(input);
    final category = inferCategory(input, type);
    final name = parseName(input);

    return ParsedTransactionData(
      amount: amount,
      type: type,
      name: name.isEmpty ? input : name,
      categoryName: category.name,
      categoryId: category.id,
      transactionAt: transactionAt,
    );
  }
}