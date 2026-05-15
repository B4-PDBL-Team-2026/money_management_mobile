import 'package:money_management_mobile/core/utils/utils.dart';

String requiredFieldMessage(String label) => '$label jangan dikosongin ya';

String positiveNumberMessage(String label) {
  return '$label harus lebih dari 0 ya';
}

String maxValueMessage(String label, int max) {
  return '$label jangan lebih dari ${CurrencyFormatter.format(max)} ya';
}

String maxLengthMessage(String label, int max) {
  return '$label maksimal $max karakter ya';
}
