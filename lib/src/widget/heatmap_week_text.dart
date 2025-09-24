import 'package:flutter/material.dart';
import '../util/date_util.dart';

class HeatMapWeekText extends StatelessWidget {
  /// The margin value for correctly space between labels.
  final EdgeInsets? margin;

  /// The double value of every block's size to fit the height.
  final double? size;

  /// The TextStyle of week labels.
  final TextStyle? textStyle;

  const HeatMapWeekText({super.key, this.margin, this.textStyle, this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (String label in DateUtil.WEEK_LABEL)
          Container(
            height: size ?? 20,
            margin: margin ?? const EdgeInsets.all(2.0),
            child: Text(label, style: TextStyle(fontSize: 12).merge(textStyle)),
          ),
      ],
    );
  }
}
