/// A simple utility class for converting between local and UTC timezones. Use this whenever send or receive DateTime from API to ensure consistency in timezone handling across the app.
class TimezoneConverter {
  static DateTime toLocal(String utcDateTimeString) {
    return DateTime.parse(utcDateTimeString).toLocal();
  }

  static String toUtcString(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }
}
