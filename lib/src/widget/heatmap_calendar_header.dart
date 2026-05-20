import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../data/heatmap_calendar_type.dart';

class HeatMapCalendarHeader extends StatelessWidget {
  const HeatMapCalendarHeader({
    super.key,
    required this.datePattern,
    required this.changeMonth,
    this.currentDate,
    this.endDate,
    this.textStyle,
    this.margin,
    this.type = HeatmapCalendarType.month,
  });

  final String datePattern;
  final EdgeInsets? margin;
  final TextStyle? textStyle;
  final DateTime? currentDate;

  /// End date of the range — only used for [HeatmapCalendarType.week] and
  /// [HeatmapCalendarType.biweek].
  final DateTime? endDate;

  final ValueChanged<int> changeMonth;

  /// Calendar view type. Determines how the header label is formatted.
  final HeatmapCalendarType type;

  String _formatLabel(String languageCode) {
    final fmt = DateFormat(datePattern, languageCode);
    final start = currentDate ?? DateTime.now();

    if ((type == HeatmapCalendarType.week ||
            type == HeatmapCalendarType.biweek) &&
        endDate != null) {
      return '${fmt.format(start)} – ${fmt.format(endDate!)}';
    }

    return fmt.format(start);
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return Container(
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Previous button.
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 14),
            onPressed: () => changeMonth(-1),
          ),

          // Label: month name or date range.
          Text(
            _formatLabel(languageCode),
            style: const TextStyle(fontSize: 12).merge(textStyle),
          ),

          // Next button.
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 14),
            onPressed: () => changeMonth(1),
          ),
        ],
      ),
    );
  }
}
