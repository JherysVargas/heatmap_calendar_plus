import '../data/constants.dart';

class DateUtil {
  /// Get start day of month.
  static DateTime startDayOfMonth(final DateTime referenceDate) =>
      DateTime(referenceDate.year, referenceDate.month, 1);

  /// Get last day of month.
  static DateTime endDayOfMonth(final DateTime referenceDate) =>
      DateTime(referenceDate.year, referenceDate.month + 1, 0);

  /// Get exactly one year before of [referenceDate].
  static DateTime oneYearBefore(final DateTime referenceDate) =>
      DateTime(referenceDate.year - 1, referenceDate.month, referenceDate.day);

  /// Separate [referenceDate]'s month to List of every weeks.
  static List<Map<DateTime, DateTime>> separatedMonth(
    final DateTime referenceDate,
    final int weekStartsWith,
  ) {
    DateTime startDate = startDayOfMonth(referenceDate);
    DateTime endDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day +
          kDefaultStartDayOfWeek -
          ((startDate.weekday - weekStartsWith) % kDefaultStartDayOfWeek) -
          1,
    );
    DateTime finalDate = endDayOfMonth(referenceDate);
    List<Map<DateTime, DateTime>> savedMonth = [];

    while (startDate.isBefore(finalDate) || startDate == finalDate) {
      savedMonth.add({startDate: endDate});
      startDate = changeDay(endDate, 1);
      endDate = changeDay(
        endDate,
        endDayOfMonth(endDate).day - startDate.day >= kDefaultStartDayOfWeek
            ? kDefaultStartDayOfWeek
            : endDayOfMonth(endDate).day - startDate.day + 1,
      );
    }
    return savedMonth;
  }

  /// Separate an arbitrary date range into a list of week rows.
  ///
  /// Every entry maps a row's start date to its end date. Rows are aligned
  /// to [weekStartsWith]: the first row is shorter when [startDate] is not
  /// the first day of the week, and the last row is shorter when [endDate]
  /// is not the last one. Rows can cross month boundaries.
  /// Time components of both dates are ignored.
  static List<Map<DateTime, DateTime>> separatedRange(
    final DateTime startDate,
    final DateTime endDate,
    final int weekStartsWith,
  ) {
    DateTime rowStart = DateTime(startDate.year, startDate.month, startDate.day);
    final DateTime finalDate =
        DateTime(endDate.year, endDate.month, endDate.day);
    final List<Map<DateTime, DateTime>> savedRange = [];

    while (!rowStart.isAfter(finalDate)) {
      final DateTime weekEnd = endDayOfWeek(rowStart, weekStartsWith);
      final DateTime rowEnd = weekEnd.isAfter(finalDate) ? finalDate : weekEnd;
      savedRange.add({rowStart: rowEnd});
      rowStart = changeDay(rowEnd, 1);
    }
    return savedRange;
  }

  /// Change day of [referenceDate].
  static DateTime changeDay(final DateTime referenceDate, final int dayCount) =>
      DateTime(
        referenceDate.year,
        referenceDate.month,
        referenceDate.day + dayCount,
      );

  /// Change month of [referenceDate].
  static DateTime changeMonth(final DateTime referenceDate, int monthCount) =>
      DateTime(
        referenceDate.year,
        referenceDate.month + monthCount,
        referenceDate.day,
      );

  /// Get the start day of the week containing [date].
  /// [weekStartsWith] = 1 for Monday, ..., 7 for Sunday.
  static DateTime startDayOfWeek(DateTime date, int weekStartsWith) {
    final offset = (date.weekday - weekStartsWith) % 7;
    return changeDay(date, -offset);
  }

  /// Get the end day of the week containing [date].
  /// Returns [startDayOfWeek] + 6 days.
  static DateTime endDayOfWeek(DateTime date, int weekStartsWith) {
    return changeDay(startDayOfWeek(date, weekStartsWith), 6);
  }
}
