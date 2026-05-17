import 'package:money_management_mobile/core/utils/utils.dart';

String requiredFieldMessage(String label) => '$label jangan dikosongin ya';

String positiveNumberMessage(String label) {
  return '$label tidak boleh kurang dari 0';
}

String maxValueMessage(String label, int max) {
  return '$label jangan lebih dari ${CurrencyFormatter.format(max)} ya';
}

String maxLengthMessage(String label, int max) {
  return '$label maksimal $max karakter ya';
}

String moreThanFieldMessage(String label, String otherLabel) {
  return '$label harus lebih besar dari $otherLabel';
}

String moreThanOrEqualFieldMessage(String label, String otherLabel) {
  return '$label harus lebih besar atau sama dengan $otherLabel';
}
