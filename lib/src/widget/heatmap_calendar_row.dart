import 'package:flutter/material.dart';
import '../data/constants.dart';
import '../util/datasets_util.dart';
import './heatmap_container.dart';
import '../data/heatmap_color_mode.dart';
import '../util/date_util.dart';
import '../util/widget_util.dart';

class HeatMapCalendarRow extends StatelessWidget {
  /// The integer value of beginning date of the week.
  final DateTime startDate;

  /// The integer value of end date of the week
  final DateTime endDate;

  /// The double value of every [HeatMapContainer]'s width and height.
  final double? size;

  /// The TextStyle of every [HeatMapContainer]'s day number.
  final TextStyle? dayTextStyle;

  /// The default background color value of [HeatMapContainer]
  final Color? defaultColor;

  /// The colorsets which give the color value for its thresholds key value.
  ///
  /// Be aware that first Color is the maximum value if [ColorMode] is [ColorMode.opacity].
  final Map<int, Color>? colorsets;

  /// The double value of [HeatMapContainer]'s borderRadius
  final double? borderRadius;

  /// Make block size flexible if value is true.
  final bool? flexible;

  /// The spacing value for every block.
  final double? spacing;

  /// The datasets which fill blocks based on its value.
  ///
  /// datasets keys have to greater or equal to [startDate] and
  /// smaller or equal to [endDate].
  final Map<DateTime, int>? datasets;

  /// ColorMode changes the color mode of blocks.
  ///
  /// [ColorMode.opacity] requires just one colorsets value and changes color
  /// dynamically based on hightest value of [datasets].
  /// [ColorMode.color] changes colors based on [colorsets] thresholdsc key value.
  final ColorMode colorMode;

  /// The integer value of the maximum value for the highest value of the month.
  final int? maxValue;

  /// Function that will be called when a block is clicked.
  ///
  /// Paratmeter gives clicked [DateTime] value.
  final Function(DateTime)? onClick;

  /// Which day the week should start?
  /// weekStartsWith = 1 for Monday, ..., weekStartsWith = 7 for Sunday.
  /// Default to 7 (the week starts wih Sunday).
  final int weekStartsWith;

  const HeatMapCalendarRow({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.colorMode,
    required this.weekStartsWith,
    this.size,
    this.dayTextStyle,
    this.defaultColor,
    this.colorsets,
    this.borderRadius,
    this.flexible,
    this.spacing,
    this.datasets,
    this.maxValue,
    this.onClick,
  });

  bool _isEmptyStart(int i) {
    return (startDate == DateUtil.startDayOfMonth(startDate) &&
        endDate.day - startDate.day != kDefaultDaysOfWeek &&
        i < ((startDate.weekday - weekStartsWith) % kDefaultDaysOfWeek));
  }

  bool _isEmptyEnd(int i) {
    return (endDate == DateUtil.endDayOfMonth(endDate) &&
        endDate.day - startDate.day != kDefaultDaysOfWeek &&
        i > ((endDate.weekday - weekStartsWith) % kDefaultDaysOfWeek));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: spacing!,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(kDefaultDaysOfWeek, (i) {
        final bool isEmpty = _isEmptyStart(i) || _isEmptyEnd(i);

        return WidgetUtil.flexibleContainer(
          isFlexible: flexible ?? false,
          child: isEmpty
              ? _buildEmptyContainer()
              // If the day is not a empty one then create HeatMapContainer.
              : _buildItemContainer(i),
        );
      }),
    );
  }

  Widget _buildEmptyContainer() {
    return Container(
      width: size ?? 42,
      height: size ?? 42,
      margin: EdgeInsets.all(spacing!),
    );
  }

  Widget _buildItemContainer(int i) {
    final date = DateTime(
      startDate.year,
      startDate.month,
      startDate.day +
          i -
          ((startDate.weekday - weekStartsWith) % kDefaultDaysOfWeek),
    );

    return HeatMapContainer(
      // Given information about the week is that
      // start day of week value and end day of week.
      //
      // So we have to give every day information to each HeatMapContainer.
      date: date,
      backgroundColor: defaultColor,
      size: size,
      textStyle: dayTextStyle,
      borderRadius: borderRadius,
      onClick: onClick,
      // If datasets has DateTime key which is equal to this HeatMapContainer's date,
      // we have to color the matched HeatMapContainer.
      //
      // If datasets is null or doesn't contains the equal DateTime value, send null.
      selectedColor: _getSelectedColor(i, date),
    );
  }

  Color? _getSelectedColor(int i, DateTime date) {
    final dataSetFound = datasets?[date];

    if (dataSetFound == null) return null;

    // Color the container with first value of colorsets
    // and set opacity value to current day's datasets key
    // devided by maxValue which is the maximum value of the month.
    if (colorMode == ColorMode.opacity) {
      return colorsets?.values.first.withValues(
        alpha: dataSetFound / (maxValue ?? 1),
      );
    }

    // Get color value from colorsets which is filtered with DateTime value
    // Using DatasetsUtil.getColor()
    return DatasetsUtil.getColor(colorsets, dataSetFound);
  }
}
