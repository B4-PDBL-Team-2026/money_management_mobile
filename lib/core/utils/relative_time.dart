import 'package:money_management_mobile/core/constants/global_constant.dart';

class RelativeTime {
  static String formatRelative(DateTime date) {
    final Duration diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) {
      return 'Baru saja';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit yang lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam yang lalu';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari yang lalu';
    } else {
      return "${date.day} ${GlobalConstant.monthMapping[date.month - 1]} ${date.year}";
    }
  }
}
