import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:sentry/sentry.dart';

class AppLogger {
  static void init({required bool enableSentry}) {
    Logger.root.level = Level.ALL;

    // tempat untuk menentukan kemana log akan dikirim
    Logger.root.onRecord.listen((record) async {
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

      if (!enableSentry || record.level < Level.WARNING) {
        return;
      }

      if (record.error != null) {
        await Sentry.captureException(
          record.error,
          stackTrace: record.stackTrace,
          withScope: (scope) {
            scope.setTag('logger', record.loggerName);
            scope.level = _toSentryLevel(record.level);
            scope.setContexts('log_record', {
              'message': record.message,
              'level': record.level.name,
              'time': record.time.toIso8601String(),
            });
          },
        );

        return;
      }

      await Sentry.captureMessage(
        '[${record.loggerName}] ${record.message}',
        level: _toSentryLevel(record.level),
      );
    });
  }

  static SentryLevel _toSentryLevel(Level level) {
    if (level >= Level.SHOUT) {
      return SentryLevel.fatal;
    }
    if (level >= Level.SEVERE) {
      return SentryLevel.error;
    }
    if (level >= Level.WARNING) {
      return SentryLevel.warning;
    }
    if (level >= Level.INFO) {
      return SentryLevel.info;
    }

    return SentryLevel.debug;
  }
}
