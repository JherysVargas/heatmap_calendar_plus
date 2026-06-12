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

  /// End date of the range. When non-null, the label renders a
  /// `start – end` range — used for [HeatmapCalendarType.week],
  /// [HeatmapCalendarType.biweek], and the dynamic-range month.
  final DateTime? endDate;

  final ValueChanged<int> changeMonth;

  /// Calendar view type. Determines how the header label is formatted.
  final HeatmapCalendarType type;

  String _formatLabel(String languageCode) {
    final fmt = DateFormat(datePattern, languageCode);
    final start = currentDate ?? DateTime.now();

    // A non-null endDate means the caller wants a range label. This covers
    // week/biweek and the dynamic-range month — the caller only passes an
    // endDate for those cases.
    if (endDate != null) {
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
