import 'package:flutter/material.dart';
import './date_util.dart';

class DatasetsUtil {
  /// Filtering [datasets] where the key is on the same month of [referenceDate].
  static Map<DateTime, int> filterMonth(
    Map<DateTime, int>? datasets,
    DateTime referenceDate,
  ) {
    return Map.from(datasets ?? {})..removeWhere(
      (date, value) =>
          !(date.isAfter(DateUtil.startDayOfMonth(referenceDate)) &&
                  date.isBefore(DateUtil.endDayOfMonth(referenceDate)) ||
              date == DateUtil.endDayOfMonth(referenceDate) ||
              date == DateUtil.startDayOfMonth(referenceDate)),
    );
  }

  /// Get maximum value of [datasets].
  static int getMaxValue(Map<DateTime, int>? datasets) {
    int result = 0;

    datasets?.forEach((date, value) {
      if (value > result) {
        result = value;
      }
    });

    return result;
  }

  /// Get color from [colorsets] using [dataValue].
  static Color? getColor(Map<int, Color>? colorsets, int? dataValue) {
    int result = 0;

    colorsets?.forEach((key, value) {
      if (key <= (dataValue ?? 0)) result = key;
    });

    return colorsets?[result];
  }

  /// Filter [datasets] to only include entries between [startDate] and [endDate] (inclusive).
  static Map<DateTime, int> filterDateRange(
    Map<DateTime, int>? datasets,
    DateTime startDate,
    DateTime endDate,
  ) {
    return Map.from(datasets ?? {})
      ..removeWhere(
        (date, _) => date.isBefore(startDate) || date.isAfter(endDate),
      );
  }
}
