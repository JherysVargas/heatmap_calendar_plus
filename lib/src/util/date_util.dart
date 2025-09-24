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
}
