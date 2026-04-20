import 'package:money_management_mobile/core/utils/utils.dart';

String requiredFieldMessage(String label) {
  return '$label tidak boleh kosong';
}

String positiveNumberMessage(String label) {
  return '$label harus lebih besar dari 0';
}

String maxValueMessage(String label, int max) {
  return '$label tidak boleh lebih dari ${CurrencyFormatter.format(max)}';
}

String maxLengthMessage(String label, int max) {
  return '$label maksimal $max karakter';
}
