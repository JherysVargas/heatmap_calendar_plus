import 'package:flutter/material.dart';
import './data/heatmap_color_mode.dart';
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
  final DateTime? initDate;

  /// The double value of every block's size.
  final double? size;

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

  const HeatMapCalendar({
    super.key,
    required this.colorsets,
    this.colorMode = ColorMode.opacity,
    this.defaultColor,
    this.datasets,
    this.initDate,
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
  });

  @override
  State<StatefulWidget> createState() => _HeatMapCalendarState();
}

class _HeatMapCalendarState extends State<HeatMapCalendar> {
  // The DateTime value of first day of the current month.
  DateTime? _currentDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      // Link controller with this state.
      widget.controller?._state = this;
      // Set _currentDate value to first day of initialized date or
      // today's month if widget.initDate is null.
      _currentDate = DateUtil.startDayOfMonth(
        widget.initDate ?? DateTime.now(),
      );
    });
  }

  void goToDate(DateTime date) {
    setState(() {
      _currentDate = DateUtil.startDayOfMonth(date);
    });
    widget.onMonthChange?.call(_currentDate!);
  }

  void changeMonth(int direction) {
    setState(() {
      _currentDate = DateUtil.changeMonth(
        _currentDate ?? DateTime.now(),
        direction,
      );
    });
    widget.onMonthChange?.call(_currentDate!);
  }

  Widget _buildHeader() {
    if (widget.headerBuilder != null) {
      return widget.headerBuilder!(context, _currentDate);
    }

    return HeatMapCalendarHeader(
      margin: widget.marginHeader,
      currentDate: _currentDate,
      changeMonth: changeMonth,
      datePattern: widget.datePattern,
      textStyle: widget.monthTextStyle,
    );
  }

  /// Expand width dynamically if [flexible] is true.
  Widget _intrinsicWidth({required Widget child}) =>
      (widget.flexible) ? child : IntrinsicWidth(child: child);

  @override
  Widget build(BuildContext context) {
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

  void nextMonth() => _state?.changeMonth(1);

  void previousMonth() => _state?.changeMonth(-1);

  void goToDate(DateTime date) {
    _state?.goToDate(date);
  }
}
