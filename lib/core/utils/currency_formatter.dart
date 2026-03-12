import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat('#,##0', 'id_ID');

  /// Format integer amount to Indonesian currency format (e.g., 12000 -> "12.000")
  static String format(int amount) {
    return _formatter.format(amount);
  }

  /// Format string amount to Indonesian currency format
  /// Returns empty string if input is empty or invalid
  static String formatString(String amount) {
    if (amount.isEmpty) return '';
    
    try {
      int value = int.parse(amount);
      return format(value);
    } catch (e) {
      return amount;
    }
  }

  /// Parse formatted currency string back to integer
  /// Returns 0 if input is empty or invalid
  static int parse(String formattedAmount) {
    if (formattedAmount.isEmpty) return 0;
    
    try {
      // Remove dots (thousand separators) and parse
      String cleanAmount = formattedAmount.replaceAll('.', '');
      return int.parse(cleanAmount);
    } catch (e) {
      return 0;
    }
  }
}
