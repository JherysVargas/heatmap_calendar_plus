import 'package:flutter/material.dart';

import '../util/date_util.dart';
import '../util/widget_util.dart';

class HeatMapCalendarWeekLabels extends StatelessWidget {
  const HeatMapCalendarWeekLabels({
    super.key,
    required this.flexible,
    this.textStyle,
    this.spacing = 4.0,
  });

  final bool flexible;
  final TextStyle? textStyle;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: spacing,
      children: <Widget>[
        for (String label in DateUtil.WEEK_LABEL.skip(1))
          WidgetUtil.flexibleContainer(
            flexible,
            false,
            Container(
              // width: widget.size ?? 42,
              alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF758EA1),
                ).merge(textStyle),
              ),
            ),
          ),
      ],
    );
  }
}
