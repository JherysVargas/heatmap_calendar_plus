import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

class HeatMapCalendarHeader extends StatelessWidget {
  const HeatMapCalendarHeader({
    super.key,
    required this.datePattern,
    required this.changeMonth,
    this.currentDate,
    this.textStyle,
    this.margin,
  });

  final String datePattern;
  final EdgeInsets? margin;
  final TextStyle? textStyle;
  final DateTime? currentDate;
  final ValueChanged<int> changeMonth;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return Container(
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Previous month button.
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 14),
            onPressed: () => changeMonth(-1),
          ),

          // Text which shows the current year and month
          Text(
            DateFormat(
              datePattern,
              languageCode,
            ).format(currentDate ?? DateTime.now()),
            style: const TextStyle(fontSize: 12).merge(textStyle),
          ),

          // Next month button.
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 14),
            onPressed: () => changeMonth(1),
          ),
        ],
      ),
    );
  }
}
