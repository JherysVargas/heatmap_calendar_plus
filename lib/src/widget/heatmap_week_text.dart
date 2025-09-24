import 'package:flutter/material.dart';

class HeatMapWeekText extends StatelessWidget {
  /// The margin value for correctly space between labels.
  final EdgeInsets? margin;

  /// The double value of every block's size to fit the height.
  final double? size;

  /// The TextStyle of week labels.
  final TextStyle? textStyle;

  /// The list of labels for week days.
  final List<String> weekDayLabels;

  const HeatMapWeekText({
    super.key,
    this.margin,
    this.textStyle,
    this.size,
    required this.weekDayLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (String label in weekDayLabels)
          Container(
            height: size ?? 20,
            margin: margin ?? const EdgeInsets.all(2.0),
            child: Text(label, style: TextStyle(fontSize: 12).merge(textStyle)),
          ),
      ],
    );
  }
}
