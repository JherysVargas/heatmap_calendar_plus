import 'package:flutter/material.dart';

import '../util/date_util.dart';

class HeatMapCalendarHeader extends StatelessWidget {
  const HeatMapCalendarHeader({
    super.key,
    this.currentDate,
    required this.changeMonth,
    this.textStyle,
  });

  final TextStyle? textStyle;
  final DateTime? currentDate;
  final ValueChanged<int> changeMonth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Previous month button.
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 14),
          onPressed: () => changeMonth(-1),
        ),

        // Text which shows the current year and month
        Text(
          '${DateUtil.MONTH_LABEL[currentDate?.month ?? 0]} ${currentDate?.year}',
          style: const TextStyle(fontSize: 12).merge(textStyle),
        ),

        // Next month button.
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 14),
          onPressed: () => changeMonth(1),
        ),
      ],
    );
  }
}
