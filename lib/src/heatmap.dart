import 'package:flutter/material.dart';
import './widget/heatmap_page.dart';
import './widget/heatmap_color_tip.dart';
import './data/heatmap_color_mode.dart';
import './util/date_util.dart';
import './data/constants.dart';

class HeatMap extends StatefulWidget {
  /// The Date value of start day of heatmap.
  ///
  /// HeatMap shows the start day of [startDate]'s week.
  ///
  /// Default value is 1 year before of the [endDate].
  /// And if [endDate] is null, then set 1 year before of the [DateTime.now].
  final DateTime? startDate;

  /// The Date value of end day of heatmap.
  ///
  /// Default value is [DateTime.now].
  final DateTime? endDate;

  /// The datasets which fill blocks based on its value.
  final Map<DateTime, int>? datasets;

  /// The color value of every block's default color.
  final Color? defaultColor;

  /// The TextTtyle of month header.
  final TextStyle? monthTextStyle;

  /// The TextStyle of week labels.
  final TextStyle? weekTextStyle;

  /// The TextStyle of day number in each block.
  final TextStyle? dayTextStyle;

  /// The double value of every block's size.
  final double? size;

  /// The colorsets which give the color value for its thresholds key value.
  ///
  /// Be aware that first Color is the maximum value if [ColorMode] is [ColorMode.opacity].
  /// Also colorsets must have at least one color.
  final Map<int, Color> colorsets;

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
  /// Parameter gives clicked [DateTime] value.
  final Function(DateTime)? onClick;

  /// The spacing value for every block.
  final double blockSpacing;

  /// The double value of every block's borderRadius.
  final double? borderRadius;

  /// Show day text in every blocks if the value is true.
  ///
  /// Default value is false.
  final bool showText;

  /// Show color tip which represents the color range at the below.
  ///
  /// Default value is true.
  final bool showColorTip;

  /// Makes heatmap scrollable if the value is true.
  ///
  /// default value is false.
  final bool scrollable;

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

  /// Which day the week should start?
  /// weekStartsWith = 1 for Monday, ..., weekStartsWith = 7 for Sunday.
  /// Default to 7 (the week starts wih Sunday).
  final int weekStartsWith;

  const HeatMap({
    super.key,
    required this.colorsets,
    this.colorMode = ColorMode.opacity,
    this.startDate,
    this.endDate,
    this.size = kDefaultBlockSizeMap,
    this.onClick,
    this.blockSpacing = kDefaultSpacingBlock,
    this.colorTipSpacing = kDefaultSpacingTip,
    this.borderRadius,
    this.datasets,
    this.defaultColor,
    this.showText = false,
    this.showColorTip = true,
    this.scrollable = false,
    this.colorTipHelper,
    this.colorTipCount,
    this.colorTipSize,
    this.monthTextStyle,
    this.weekTextStyle,
    this.dayTextStyle,
    this.weekStartsWith = kDefaultStartDayOfWeek,
  });

  @override
  State<StatefulWidget> createState() => _HeatMap();
}

class _HeatMap extends State<HeatMap> {
  /// Put child into [SingleChildScrollView] so that user can scroll the widet horizontally.
  Widget _scrollableHeatMap(Widget child) {
    return widget.scrollable
        ? SingleChildScrollView(
            reverse: true,
            scrollDirection: Axis.horizontal,
            child: child,
          )
        : child;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Heatmap Widget.
        _scrollableHeatMap(
          HeatMapPage(
            weekStartsWith: widget.weekStartsWith,
            endDate: widget.endDate ?? DateTime.now(),
            startDate:
                widget.startDate ??
                DateUtil.oneYearBefore(widget.endDate ?? DateTime.now()),
            colorMode: widget.colorMode,
            size: widget.size,
            datasets: widget.datasets,
            defaultColor: widget.defaultColor,
            dayTextStyle: widget.dayTextStyle,
            monthTextStyle: widget.monthTextStyle,
            weekTextStyle: widget.weekTextStyle,
            colorsets: widget.colorsets,
            borderRadius: widget.borderRadius,
            onClick: widget.onClick,
            spacing: widget.blockSpacing,
            showText: widget.showText,
          ),
        ),

        // Show HeatMapColorTip if showColorTip is true.
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
    );
  }
}
