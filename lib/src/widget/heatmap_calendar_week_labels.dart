import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../data/constants.dart';
import '../util/date_util.dart';
import '../util/widget_util.dart';

class HeatMapCalendarWeekLabels extends StatelessWidget {
  const HeatMapCalendarWeekLabels({
    super.key,
    required this.flexible,
    required this.startDayOfWeek,
    this.textStyle,
    this.spacing = 4.0,
    this.size,
  });

  final double? size;
  final int startDayOfWeek;
  final bool flexible;
  final TextStyle? textStyle;
  final double spacing;

  static final fixedDate = DateTime(2021, 1, 4);

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: spacing,
      children: List.generate(kDefaultDaysOfWeek, (index) {
        final dayCount = (index + startDayOfWeek - 1) % kDefaultDaysOfWeek;

        return WidgetUtil.flexibleContainer(
          isFlexible: flexible,
          child: Container(
            width: size,
            alignment: Alignment.center,
            child: Text(
              DateFormat.E(
                languageCode,
              ).format(DateUtil.changeDay(fixedDate, dayCount)),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF758EA1),
              ).merge(textStyle),
            ),
          ),
        );
      }),
    );
  }
}
