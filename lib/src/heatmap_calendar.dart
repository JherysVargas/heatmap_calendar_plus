import 'package:flutter/material.dart';
import './data/heatmap_color_mode.dart';
import './widget/heatmap_calendar_page.dart';
import './widget/heatmap_color_tip.dart';
import './util/date_util.dart';
import './data/constants.dart';
import './widget/heatmap_calendar_header.dart';
import './widget/heatmap_calendar_week_labels.dart';

class HeatMapCalendar extends StatefulWidget {
  /// The datasets which fill blocks based on its value.
  final Map<DateTime, int>? datasets;

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

  /// The text color value of every blocks.
  final Color? textColor;

  /// The double value of every block's fontSize.
  final double? fontSize;

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
  final bool? showColorTip;

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

  const HeatMapCalendar({
    super.key,
    required this.colorsets,
    this.colorMode = ColorMode.opacity,
    this.defaultColor,
    this.datasets,
    this.initDate,
    this.size = kDefaultBlockSizeCalendar,
    this.fontSize,
    this.monthTextStyle,
    this.textColor,
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
  });

  @override
  State<StatefulWidget> createState() => _HeatMapCalendar();
}

class _HeatMapCalendar extends State<HeatMapCalendar> {
  // The DateTime value of first day of the current month.
  DateTime? _currentDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      // Set _currentDate value to first day of initialized date or
      // today's month if widget.initDate is null.
      _currentDate = DateUtil.startDayOfMonth(
        widget.initDate ?? DateTime.now(),
      );
    });
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

  /// Expand width dynamically if [flexible] is true.
  Widget _intrinsicWidth({required Widget child}) =>
      (widget.flexible) ? child : IntrinsicWidth(child: child);

  @override
  Widget build(BuildContext context) {
    return _intrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          HeatMapCalendarHeader(
            margin: widget.marginHeader,
            currentDate: _currentDate,
            changeMonth: changeMonth,
            textStyle: widget.monthTextStyle,
          ),
          HeatMapCalendarWeekLabels(
            flexible: widget.flexible,
            textStyle: widget.weekTextStyle,
          ),
          HeatMapCalendarPage(
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
          if (widget.showColorTip == true)
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
