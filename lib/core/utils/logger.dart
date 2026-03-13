import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class AppLogger {
  static void init() {
    Logger.root.level = Level.ALL;

    // tempat untuk menentukan kemana log akan dikirim
    Logger.root.onRecord.listen((record) {
      dev.log(
        record.message,
        time: record.time,
        level: record.level.value,
        name: record.loggerName,
        error: record.error,
        stackTrace: record.stackTrace,
      );

      // print ke terminal hanya saat debug mode, non-blocking
      if (kDebugMode) {
        final buffer = StringBuffer()
          ..write('[${record.level.name}] ')
          ..write('[${record.loggerName}] ')
          ..write(record.message);

        if (record.error != null) {
          buffer
            ..writeln()
            ..write('Error: ${record.error}');
        }
        if (record.stackTrace != null) {
          buffer
            ..writeln()
            ..write('StackTrace: ${record.stackTrace}');
        }

        debugPrint(buffer.toString());
      }
    });
  }
}
