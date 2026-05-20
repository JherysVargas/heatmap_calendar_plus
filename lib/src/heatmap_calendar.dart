import 'package:flutter/material.dart';
import './data/heatmap_color_mode.dart';
import './data/heatmap_calendar_type.dart';
import './data/heatmap_cell_style.dart';
import './heatmap.dart';
import './widget/heatmap_calendar_page.dart';
import './widget/heatmap_color_tip.dart';
import './util/date_util.dart';
import './data/constants.dart';
import './widget/heatmap_calendar_header.dart';
import './widget/heatmap_calendar_week_labels.dart';

typedef HeaderBuilder =
    Widget Function(BuildContext context, DateTime? currentDate);

class HeatMapCalendar extends StatefulWidget {
  /// The datasets which fill blocks based on its value.
  final Map<DateTime, int>? datasets;

  /// Which day the week should start?
  /// weekStartsWith = 1 for Monday, ..., weekStartsWith = 7 for Sunday.
  /// Default to 7 (the week starts wih Sunday).
  final int weekStartsWith;

  /// The color value of every block's default color.
  final Color? defaultColor;

  /// The colorsets which give the color value for its thresholds key value.
  ///
  /// Be aware that first Color is the maximum value if [ColorMode] is [ColorMode.opacity].
  /// Also colorsets must have at least one color.
  final Map<int, Color> colorsets;

  /// The double value of every block's borderRadius.
  final double? borderRadius;

  /// The date values of initial year and month.
  final DateTime? startDate;

  /// The double value of every block's size.
  final double size;

  /// The TextTtyle of month header.
  final TextStyle? monthTextStyle;

  /// The TextStyle of week labels.
  final TextStyle? weekTextStyle;

  /// The TextStyle of day number in each block.
  final TextStyle? dayTextStyle;

  /// Make block size flexible if value is true.
  ///
  /// Default value is false.
  final bool flexible;

  /// The spacing value for every block.
  final double blockSpacing;

  /// ColorMode changes the color mode of blocks.
  ///
  /// [ColorMode.opacity] requires just one colorsets value and changes color
  /// dynamically based on hightest value of [datasets].
  /// [ColorMode.color] changes colors based on [colorsets] thresholds key value.
  ///
  /// Default value is [ColorMode.opacity].
  final ColorMode colorMode;

  /// Function that will be called when a block is clicked.
  ///
  /// Paratmeter gives clicked [DateTime] value.
  final Function(DateTime)? onClick;

  /// Function that will be called when month is changed.
  ///
  /// Paratmeter gives [DateTime] value of current month.
  final Function(DateTime)? onMonthChange;

  /// Show color tip which represents the color range at the below.
  ///
  /// Default value is true.
  final bool showColorTip;

  /// Widgets which shown at left and right side of colorTip.
  ///
  /// First value is the left side widget and second value is the right side widget.
  /// Be aware that [colorTipHelper.length] have to greater or equal to 2.
  /// Give null value makes default 'less' and 'more' [Text].
  final List<Widget?>? colorTipHelper;

  /// The integer value which represents the number of [HeatMapColorTip]'s tip container.
  final int? colorTipCount;

  /// The double value of [HeatMapColorTip]'s tip container's size.
  final double? colorTipSize;

  /// The spacing value between tip containers and left/right widgets.
  final double colorTipSpacing;

  /// The EdgeInsets value of margin for header.
  final EdgeInsets? marginHeader;

  /// Custom header builder.
  final HeaderBuilder? headerBuilder;

  /// Controller for manipulating the state of [HeatMapCalendar].
  final HeatMapCalendarController? controller;

  /// The date format pattern of date header.
  final String datePattern;

  /// The calendar view type.
  ///
  /// - [HeatmapCalendarType.month] (default): monthly calendar — non-breaking.
  /// - [HeatmapCalendarType.week]: single-week view (7 blocks).
  /// - [HeatmapCalendarType.biweek]: two-week view (14 blocks).
  /// - [HeatmapCalendarType.year]: delegates to [HeatMap] (full-year heatmap).
  final HeatmapCalendarType type;

  /// The end date for the year heatmap view ([HeatmapCalendarType.year]).
  ///
  /// Only used when [type] is [HeatmapCalendarType.year].
  /// Defaults to [DateTime.now] inside [HeatMap].
  final DateTime? endDate;

  /// Reverse scroll direction when [scrollable] is true.
  ///
  /// Only used when [type] is [HeatmapCalendarType.year].
  /// Default value is true.
  final bool reversed;

  /// Makes the year heatmap scrollable.
  ///
  /// Only used when [type] is [HeatmapCalendarType.year].
  /// Default value is false.
  final bool scrollable;

  /// Show day text in every block if value is true.
  ///
  /// When null, defaults to true for [HeatmapCalendarType.month]/week/biweek
  /// and false for [HeatmapCalendarType.year] (matching [HeatMap] default).
  final bool? showText;

  /// Optional per-cell style resolver.
  ///
  /// When provided, it is called for each cell's [DateTime]. If it returns a
  /// [HeatMapCellStyle] with a non-null [HeatMapCellStyle.color], that color
  /// takes full priority over the global [colorsets] / [colorMode] logic for
  /// that specific date. Returning `null` (or a style with `color: null`) falls
  /// back to the default threshold-based coloring.
  ///
  /// This works for all calendar types: `month`, `week`, `biweek`, and `year`.
  ///
  /// Example — color cells green when income exceeds expense, red otherwise:
  /// ```dart
  /// cellStyleResolver: (date) {
  ///   final income = getIncome(date);
  ///   final expense = getExpense(date);
  ///   if (income == 0 && expense == 0) return null;
  ///   return HeatMapCellStyle(
  ///     color: income > expense ? Colors.green : Colors.red,
  ///   );
  /// },
  /// ```
  final HeatMapCellStyleResolver? cellStyleResolver;

  const HeatMapCalendar({
    super.key,
    required this.colorsets,
    this.colorMode = ColorMode.opacity,
    this.defaultColor,
    this.datasets,
    this.startDate,
    this.size = kDefaultBlockSizeCalendar,
    this.monthTextStyle,
    this.weekTextStyle,
    this.dayTextStyle,
    this.borderRadius,
    this.flexible = false,
    this.blockSpacing = kDefaultSpacingBlock,
    this.onClick,
    this.onMonthChange,
    this.showColorTip = true,
    this.colorTipHelper,
    this.colorTipCount,
    this.colorTipSize,
    this.colorTipSpacing = kDefaultSpacingTip,
    this.marginHeader,
    this.headerBuilder,
    this.controller,
    this.datePattern = kDefaultDatePatternCalendar,
    this.weekStartsWith = kDefaultStartDayOfWeek,
    this.type = HeatmapCalendarType.month,
    this.endDate,
    this.reversed = true,
    this.scrollable = true,
    this.showText,
    this.cellStyleResolver,
  });

  @override
  State<StatefulWidget> createState() => _HeatMapCalendarState();
}

class _HeatMapCalendarState extends State<HeatMapCalendar> {
  // The DateTime value of the current reference date.
  // For month view: first day of the current month.
  // For week/biweek view: the actual reference date (any day of the week).
  DateTime? _currentDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      // Link controller with this state.
      widget.controller?._state = this;
      // For month/year view: anchor to the first day of the month.
      // For week/biweek view: keep the raw date so startDayOfWeek is computed correctly.
      final base = widget.startDate ?? DateTime.now();
      _currentDate =
          (widget.type == HeatmapCalendarType.month ||
              widget.type == HeatmapCalendarType.year)
          ? DateUtil.startDayOfMonth(base)
          : base;
    });
  }

  void goToDate(DateTime date) {
    setState(() {
      _currentDate =
          (widget.type == HeatmapCalendarType.month ||
              widget.type == HeatmapCalendarType.year)
          ? DateUtil.startDayOfMonth(date)
          : date;
    });
    widget.onMonthChange?.call(_currentDate!);
  }

  void changePeriod(int direction) {
    setState(() {
      final base = _currentDate ?? DateTime.now();
      _currentDate = switch (widget.type) {
        HeatmapCalendarType.week => DateUtil.changeDay(base, direction * 7),
        HeatmapCalendarType.biweek => DateUtil.changeDay(base, direction * 14),
        _ => DateUtil.changeMonth(base, direction),
      };
    });
    widget.onMonthChange?.call(_currentDate!);
  }

  /// Returns the effective date pattern for the header.
  ///
  /// For week/biweek views, falls back to [kDefaultDatePatternWeek] when the
  /// user did not override [datePattern] (i.e. it is still the month default).
  String get _effectiveDatePattern {
    final isWeekType =
        widget.type == HeatmapCalendarType.week ||
        widget.type == HeatmapCalendarType.biweek;
    final isDefaultPattern = widget.datePattern == kDefaultDatePatternCalendar;
    return (isWeekType && isDefaultPattern)
        ? kDefaultDatePatternWeek
        : widget.datePattern;
  }

  /// Computes the header start date for week/biweek range display.
  ///
  /// Anchors to [DateUtil.startDayOfWeek] so the header is always consistent
  /// with the content rows rendered by [HeatMapCalendarPage].
  DateTime? get _headerStartDate {
    if (_currentDate == null) return null;
    return switch (widget.type) {
      HeatmapCalendarType.week ||
      HeatmapCalendarType.biweek =>
        DateUtil.startDayOfWeek(_currentDate!, widget.weekStartsWith),
      _ => _currentDate,
    };
  }

  /// Computes the header end date for week/biweek range display.
  DateTime? get _headerEndDate {
    final start = _headerStartDate;
    if (start == null) return null;
    return switch (widget.type) {
      HeatmapCalendarType.week => DateUtil.endDayOfWeek(
        start,
        widget.weekStartsWith,
      ),
      HeatmapCalendarType.biweek => DateUtil.changeDay(
        DateUtil.endDayOfWeek(start, widget.weekStartsWith),
        7,
      ),
      _ => null,
    };
  }

  Widget _buildHeader() {
    if (widget.headerBuilder != null) {
      return widget.headerBuilder!(context, _currentDate);
    }

    return HeatMapCalendarHeader(
      margin: widget.marginHeader,
      currentDate: _headerStartDate,
      endDate: _headerEndDate,
      changeMonth: changePeriod,
      datePattern: _effectiveDatePattern,
      textStyle: widget.monthTextStyle,
      type: widget.type,
    );
  }

  /// Expand width dynamically if [flexible] is true.
  Widget _intrinsicWidth({required Widget child}) =>
      (widget.flexible) ? child : IntrinsicWidth(child: child);

  /// Build the year heatmap view by delegating to [HeatMap].
  Widget _buildYearView() {
    return HeatMap(
      colorsets: widget.colorsets,
      colorMode: widget.colorMode,
      startDate: widget.startDate,
      endDate: widget.endDate,
      datasets: widget.datasets,
      defaultColor: widget.defaultColor,
      size: widget.size / 2,
      monthTextStyle: widget.monthTextStyle,
      weekTextStyle: widget.weekTextStyle,
      dayTextStyle: widget.dayTextStyle,
      borderRadius: widget.borderRadius,
      blockSpacing: widget.blockSpacing,
      onClick: widget.onClick,
      showText: widget.showText ?? false,
      showColorTip: widget.showColorTip,
      colorTipHelper: widget.colorTipHelper,
      colorTipCount: widget.colorTipCount,
      colorTipSize: widget.colorTipSize,
      colorTipSpacing: widget.colorTipSpacing,
      weekStartsWith: widget.weekStartsWith,
      scrollable: widget.scrollable,
      reversed: widget.reversed,
      cellStyleResolver: widget.cellStyleResolver,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == HeatmapCalendarType.year) {
      return _buildYearView();
    }

    return _intrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildHeader(),
          HeatMapCalendarWeekLabels(
            size: widget.size,
            startDayOfWeek: widget.weekStartsWith,
            flexible: widget.flexible,
            textStyle: widget.weekTextStyle,
          ),
          HeatMapCalendarPage(
            weekStartsWith: widget.weekStartsWith,
            baseDate: _currentDate ?? DateTime.now(),
            colorMode: widget.colorMode,
            flexible: widget.flexible,
            size: widget.size,
            defaultColor: widget.defaultColor,
            dayTextStyle: widget.dayTextStyle,
            spacing: widget.blockSpacing,
            datasets: widget.datasets,
            colorsets: widget.colorsets,
            borderRadius: widget.borderRadius,
            onClick: widget.onClick,
            type: widget.type,
            showText: widget.showText,
            cellStyleResolver: widget.cellStyleResolver,
          ),
          if (widget.showColorTip)
            HeatMapColorTip(
              colorMode: widget.colorMode,
              colorsets: widget.colorsets,
              leftWidget: widget.colorTipHelper?[0],
              rightWidget: widget.colorTipHelper?[1],
              containerCount: widget.colorTipCount,
              size: widget.colorTipSize,
              spacing: widget.colorTipSpacing,
            ),
        ],
      ),
    );
  }
}

class HeatMapCalendarController {
  _HeatMapCalendarState? _state;

  DateTime? get currentDate => _state?._currentDate;

  void nextMonth() => _state?.changePeriod(1);

  void previousMonth() => _state?.changePeriod(-1);

  void goToDate(DateTime date) {
    _state?.goToDate(date);
  }
}
