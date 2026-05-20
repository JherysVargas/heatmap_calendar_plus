import 'package:flutter/material.dart';
import './heatmap_container.dart';
import '../util/date_util.dart';
import '../util/datasets_util.dart';
import '../data/heatmap_color_mode.dart';
import '../data/heatmap_cell_style.dart';
import '../data/constants.dart';

class HeatMapColumn extends StatelessWidget {
  /// The List widgets of [HeatMapContainer].
  ///
  /// It includes every days of the week and
  /// if one week doesn't have 7 days, it will be filled with empty [Container].
  final List<Widget> dayContainers;

  /// The List widgets of empty [Container].
  ///
  /// It only processes when given week's length is not 7.
  final List<Widget> emptySpace;

  /// The date value of first day of given week.
  final DateTime startDate;

  /// The date value of last day of given week.
  final DateTime endDate;

  /// Which day the week should start?
  /// weekStartsWith = 1 for Monday, ..., weekStartsWith = 7 for Sunday.
  /// Default to 7 (the week starts wih Sunday).
  final int weekStartsWith;

  /// The double value of every [HeatMapContainer]'s width and height.
  final double? size;

  /// The TextStyle of every [HeatMapContainer]'s day number.
  final TextStyle? dayTextStyle;

  /// The default background color value of [HeatMapContainer].
  final Color? defaultColor;

  /// The datasets which fill blocks based on its value.
  ///
  /// datasets keys have to greater or equal to [startDate] and
  /// smaller or equal to [endDate].
  final Map<DateTime, int>? datasets;

  /// The colorsets which give the color value for its thresholds key value.
  ///
  /// Be aware that first Color is the maximum value if [ColorMode] is [ColorMode.opacity].
  final Map<int, Color>? colorsets;

  /// ColorMode changes the color mode of blocks.
  ///
  /// [ColorMode.opacity] requires just one colorsets value and changes color
  /// dynamically based on hightest value of [datasets].
  /// [ColorMode.color] changes colors based on [colorsets] thresholdsc key value.
  final ColorMode colorMode;

  /// The double value of [HeatMapContainer]'s borderRadius.
  final double? borderRadius;

  /// The spacing value for every block.
  final double spacing;

  /// Function that will be called when a block is clicked.
  ///
  /// Paratmeter gives clicked [DateTime] value.
  final Function(DateTime)? onClick;

  /// The integer value of the maximum value for the highest value of the month.
  final int? maxValue;

  /// Show day text in every blocks if the value is true.
  final bool? showText;

  // The number of day blocks to draw. This should be seven for all but the
  // current week.
  final int numDays;

  /// Optional per-cell style resolver.
  ///
  /// When provided, it is called for each cell's [DateTime]. If it returns a
  /// [HeatMapCellStyle] with a non-null [HeatMapCellStyle.color], that color
  /// takes full priority over [colorsets] / [colorMode] for that specific date.
  /// Returning `null` falls back to the default threshold-based coloring.
  final HeatMapCellStyleResolver? cellStyleResolver;

  HeatMapColumn({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.colorMode,
    required this.numDays,
    required this.weekStartsWith,
    this.size,
    this.defaultColor,
    this.datasets,
    this.dayTextStyle,
    this.borderRadius,
    this.spacing = kDefaultSpacingBlock,
    this.colorsets,
    this.onClick,
    this.maxValue,
    this.showText,
    this.cellStyleResolver,
  })  : dayContainers = List.generate(
          numDays,
          (i) => _buildDayContainer(
            date: DateUtil.changeDay(startDate, i),
            colorMode: colorMode,
            datasets: datasets,
            colorsets: colorsets,
            defaultColor: defaultColor,
            size: size,
            dayTextStyle: dayTextStyle,
            borderRadius: borderRadius,
            onClick: onClick,
            showText: showText,
            maxValue: maxValue,
            cellStyleResolver: cellStyleResolver,
          ),
        ),
        // Fill emptySpace list only if given week doesn't have 7 days.
        emptySpace = (numDays != 7)
            ? List.generate(
                7 - numDays,
                (i) => SizedBox(width: size ?? 42, height: size ?? 42),
              )
            : [];

  /// Builds a single [HeatMapContainer] for [date], applying [cellStyleResolver]
  /// with priority over threshold-based [colorsets] coloring.
  static HeatMapContainer _buildDayContainer({
    required DateTime date,
    required ColorMode colorMode,
    Map<DateTime, int>? datasets,
    Map<int, Color>? colorsets,
    Color? defaultColor,
    double? size,
    TextStyle? dayTextStyle,
    double? borderRadius,
    Function(DateTime)? onClick,
    bool? showText,
    int? maxValue,
    HeatMapCellStyleResolver? cellStyleResolver,
  }) {
    // 1. Per-cell resolver takes full priority when it returns a non-null color.
    final resolvedColor = cellStyleResolver?.call(date)?.color;

    Color? selectedColor;
    if (resolvedColor != null) {
      selectedColor = resolvedColor;
    } else {
      // 2. Fallback: threshold-based coloring via datasets + colorsets.
      final dataValue =
          (datasets?.containsKey(date) ?? false) ? datasets![date] : null;
      if (dataValue != null) {
        selectedColor = colorMode == ColorMode.opacity
            ? colorsets?.values.first.withValues(
                alpha: dataValue / (maxValue ?? 1),
              )
            : DatasetsUtil.getColor(colorsets, dataValue);
      }
    }

    return HeatMapContainer(
      date: date,
      backgroundColor: defaultColor,
      size: size,
      textStyle: dayTextStyle,
      borderRadius: borderRadius,
      onClick: onClick,
      showText: showText,
      selectedColor: selectedColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: spacing,
      children: <Widget>[...dayContainers, ...emptySpace],
    );
  }
}
