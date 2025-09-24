class DateUtil {
  //TODO: Localize month and week labels.
  static const int DAYS_IN_WEEK = 7;

  //TODO: Localize month labels.
  static const List<String> MONTH_LABEL = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  //TODO: Localize short month labels.
  static const List<String> SHORT_MONTH_LABEL = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  //TODO: Localize week labels.
  static const List<String> WEEK_LABEL = [
    '',
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  /// Get start day of month.
  static DateTime startDayOfMonth(final DateTime referenceDate) => DateTime(
        referenceDate.year,
        referenceDate.month,
        1,
      );

  /// Get last day of month.
  static DateTime endDayOfMonth(final DateTime referenceDate) => DateTime(
        referenceDate.year,
        referenceDate.month + 1,
        0,
      );

  /// Get exactly one year before of [referenceDate].
  static DateTime oneYearBefore(final DateTime referenceDate) => DateTime(
        referenceDate.year - 1,
        referenceDate.month,
        referenceDate.day,
      );

  /// Separate [referenceDate]'s month to List of every weeks.
  static List<Map<DateTime, DateTime>> separatedMonth(
    final DateTime referenceDate,
  ) {
    DateTime _startDate = startDayOfMonth(referenceDate);
    DateTime _endDate = DateTime(
      _startDate.year,
      _startDate.month,
      ((_startDate.day + DAYS_IN_WEEK) - (_startDate.weekday % DAYS_IN_WEEK)) -
          1,
    );
    DateTime _finalDate = endDayOfMonth(referenceDate);
    List<Map<DateTime, DateTime>> _savedMonth = [];

    while (_startDate.isBefore(_finalDate) || _startDate == _finalDate) {
      _savedMonth.add({_startDate: _endDate});
      _startDate = changeDay(_endDate, 1);
      _endDate = changeDay(
        _endDate,
        endDayOfMonth(_endDate).day - _startDate.day >= DAYS_IN_WEEK
            ? DAYS_IN_WEEK
            : endDayOfMonth(_endDate).day - _startDate.day + 1,
      );
    }
    return _savedMonth;
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
