import 'package:flutter/material.dart';
import './heatmap_calendar_row.dart';
import '../util/date_util.dart';
import '../util/datasets_util.dart';
import '../data/heatmap_color_mode.dart';
import '../data/heatmap_calendar_type.dart';
import '../data/heatmap_cell_style.dart';
import '../data/constants.dart';

class HeatMapCalendarPage extends StatelessWidget {
  /// The DateTime value which contains the current calendar's date value.
  final DateTime baseDate;

  /// Which day the week should start?
  /// weekStartsWith = 1 for Monday, ..., weekStartsWith = 7 for Sunday.
  /// Default to 7 (the week starts wih Sunday).
  final int weekStartsWith;

  /// The list value of the map value that contains
  /// separated start and end of every weeks on month.
  ///
  /// Separate [datasets] using [DateUtil.separatedMonth].
  final List<Map<DateTime, DateTime>> separatedDate;

  /// The spacing value for every block.
  final double spacing;

  /// Make block size flexible if value is true.
  final bool? flexible;

  /// The double value of every block's width and height.
  final double? size;

  /// The TextStyle of every [HeatMapContainer]'s day number.
  final TextStyle? dayTextStyle;

  /// The datasets which fill blocks based on its value.
  final Map<DateTime, int>? datasets;

  /// The default background color value of every blocks
  final Color? defaultColor;

  /// ColorMode changes the color mode of blocks.
  ///
  /// [ColorMode.opacity] requires just one colorsets value and changes color
  /// dynamically based on hightest value of [datasets].
  /// [ColorMode.color] changes colors based on [colorsets] thresholds key value.
  final ColorMode colorMode;

  /// The colorsets which give the color value for its thresholds key value.
  ///
  /// Be aware that first Color is the maximum value if [ColorMode] is [ColorMode.opacity].
  final Map<int, Color>? colorsets;

  /// The double value of every block's borderRadius
  final double? borderRadius;

  /// The integer value of the maximum value for the [datasets].
  ///
  /// Filtering [datasets] with [baseDate] using [DatasetsUtil.filterMonth].
  /// And get highest key value of filtered datasets using [DatasetsUtil.getMaxValue].
  final int? maxValue;

  /// Function that will be called when a block is clicked.
  ///
  /// Paratmeter gives clicked [DateTime] value.
  final Function(DateTime)? onClick;

  /// The calendar view type.
  ///
  /// Default value is [HeatmapCalendarType.month].
  final HeatmapCalendarType type;

  /// Show day text in every block if value is true.
  ///
  /// Default value is true (via [HeatMapContainer] default).
  final bool? showText;

  /// Optional per-cell style resolver. Propagated to every [HeatMapCalendarRow].
  ///
  /// See [HeatMapCellStyleResolver] for full documentation.
  final HeatMapCellStyleResolver? cellStyleResolver;

  HeatMapCalendarPage({
    super.key,
    required this.baseDate,
    required this.colorMode,
    required this.weekStartsWith,
    this.flexible,
    this.size,
    this.dayTextStyle,
    this.defaultColor,
    this.spacing = kDefaultSpacingBlock,
    this.datasets,
    this.colorsets,
    this.borderRadius,
    this.onClick,
    this.type = HeatmapCalendarType.month,
    this.showText,
    this.cellStyleResolver,
  }) : separatedDate = DateUtil.separatedMonth(baseDate, weekStartsWith),
       maxValue = DatasetsUtil.getMaxValue(
         DatasetsUtil.filterMonth(datasets, baseDate),
       );

  // ─── helpers ─────────────────────────────────────────────────────────────

  HeatMapCalendarRow _buildRow({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return HeatMapCalendarRow(
      startDate: startDate,
      endDate: endDate,
      colorMode: colorMode,
      size: size,
      weekStartsWith: weekStartsWith,
      dayTextStyle: dayTextStyle,
      defaultColor: defaultColor,
      colorsets: colorsets,
      borderRadius: borderRadius,
      flexible: flexible,
      spacing: spacing,
      maxValue: maxValue,
      onClick: onClick,
      showText: showText,
      cellStyleResolver: cellStyleResolver,
      datasets: DatasetsUtil.filterDateRange(datasets, startDate, endDate),
    );
  }

  // ─── build paths ─────────────────────────────────────────────────────────

  Widget _buildWeekView() {
    final start = DateUtil.startDayOfWeek(baseDate, weekStartsWith);
    final end = DateUtil.endDayOfWeek(baseDate, weekStartsWith);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: _buildRow(startDate: start, endDate: end),
    );
  }

  Widget _buildBiweekView() {
    final week1Start = DateUtil.startDayOfWeek(baseDate, weekStartsWith);
    final week1End = DateUtil.endDayOfWeek(baseDate, weekStartsWith);
    final week2Start = DateUtil.changeDay(week1Start, 7);
    final week2End = DateUtil.changeDay(week1End, 7);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        spacing: spacing,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(startDate: week1Start, endDate: week1End),
          _buildRow(startDate: week2Start, endDate: week2End),
        ],
      ),
    );
  }

  Widget _buildMonthView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        spacing: spacing,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var date in separatedDate)
            HeatMapCalendarRow(
              startDate: date.keys.first,
              endDate: date.values.first,
              colorMode: colorMode,
              size: size,
              weekStartsWith: weekStartsWith,
              dayTextStyle: dayTextStyle,
              defaultColor: defaultColor,
              colorsets: colorsets,
              borderRadius: borderRadius,
              flexible: flexible,
              spacing: spacing,
              maxValue: maxValue,
              onClick: onClick,
              showText: showText,
              cellStyleResolver: cellStyleResolver,
              datasets: Map.from(datasets ?? {})
                ..removeWhere(
                  (key, value) =>
                      !(key.isAfter(date.keys.first) &&
                              key.isBefore(date.values.first) ||
                          key == date.keys.first ||
                          key == date.values.first),
                ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case HeatmapCalendarType.week:
        return _buildWeekView();
      case HeatmapCalendarType.biweek:
        return _buildBiweekView();
      case HeatmapCalendarType.month:
      case HeatmapCalendarType.year:
        return _buildMonthView();
    }
  }
}
