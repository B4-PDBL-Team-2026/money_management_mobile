import 'package:logging/logging.dart';
import 'dart:developer' as dev;

class AppLogger {
  static void init() {
    Logger.root.level = Level.ALL;

    // tempat untuk menentukan kemana log akan dikirim
    Logger.root.onRecord.listen((record) {
      // print ke console
      dev.log(
        record.message,
        time: record.time,
        level: record.level.value,
        name: record.loggerName,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    });
  }
}
