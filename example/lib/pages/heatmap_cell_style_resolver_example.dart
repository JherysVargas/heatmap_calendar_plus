import 'dart:math';

import 'package:flutter/material.dart';
import 'package:heatmap_calendar_plus/heatmap_calendar_plus.dart';

/// Demonstrates [HeatMapCellStyleResolver] by simulating daily income and
/// expense totals. Each day is colored:
///
/// - 🟢 Green  — income > expense
/// - 🔴 Red    — expense >= income (and at least one value > 0)
/// - ⬜ Default — no activity that day
class HeatMapCellStyleResolverExample extends StatefulWidget {
  const HeatMapCellStyleResolverExample({Key? key}) : super(key: key);

  @override
  State<HeatMapCellStyleResolverExample> createState() =>
      _HeatMapCellStyleResolverExampleState();
}

class _HeatMapCellStyleResolverExampleState
    extends State<HeatMapCellStyleResolverExample> {
  HeatmapCalendarType _calendarType = HeatmapCalendarType.month;

  /// Simulated income totals per day (keyed by normalized DateTime).
  late final Map<DateTime, double> _incomeByDay;

  /// Simulated expense totals per day (keyed by normalized DateTime).
  late final Map<DateTime, double> _expenseByDay;

  /// Intensity dataset for the heatmap (total activity = income + expense).
  late final Map<DateTime, int> _datasets;

  @override
  void initState() {
    super.initState();
    _generateSimulatedData();
  }

  /// Generates random income/expense data for the current month so the demo
  /// is self-contained and easy to understand at a glance.
  void _generateSimulatedData() {
    final rnd = Random(42); // fixed seed for reproducible demo
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);

    _incomeByDay = {};
    _expenseByDay = {};
    _datasets = {};

    for (var day = 1; day <= daysInMonth; day++) {
      // Skip ~30 % of days to simulate days with no activity.
      if (rnd.nextDouble() < 0.3) continue;

      final date = DateTime(now.year, now.month, day);
      final income = rnd.nextDouble() * 500;
      final expense = rnd.nextDouble() * 500;

      _incomeByDay[date] = income;
      _expenseByDay[date] = expense;

      // Intensity = total activity volume (used by colorsets as fallback).
      _datasets[date] = ((income + expense) / 10).round().clamp(1, 100);
    }
  }

  /// The resolver: returns green when income > expense, red otherwise.
  HeatMapCellStyle? _cellStyleResolver(DateTime date) {
    final income = _incomeByDay[date];
    final expense = _expenseByDay[date];

    // No activity on this day → use defaultColor (no override).
    if (income == null && expense == null) return null;

    final i = income ?? 0;
    final e = expense ?? 0;

    return HeatMapCellStyle(
      color: i > e ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cell Style Resolver')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // — Type selector ————————————————————————————————————————————
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: SizedBox(
                height: 44,
                child: Row(
                  spacing: 6,
                  children: HeatmapCalendarType.values
                      .where((t) => t != HeatmapCalendarType.year)
                      .map(
                        (type) => Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                setState(() => _calendarType = type),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _calendarType == type
                                  ? Colors.blueAccent
                                  : null,
                            ),
                            child: Text(
                              type.name[0].toUpperCase() +
                                  type.name.substring(1),
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            // — Month view ————————————————————————————————————————————————
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: HeatMapCalendar(
                  flexible: true,
                  type: _calendarType,
                  datasets: _datasets,
                  colorMode: ColorMode.color,
                  blockSpacing: 6,
                  weekStartsWith: 1,
                  marginHeader: const EdgeInsets.only(bottom: 10),
                  // Fallback colorsets (used only when resolver returns null).
                  colorsets: const {
                    0: Color(0xFFE0E0E0),
                    1: Color(0xFFBDBDBD),
                  },
                  // ✅ Per-cell color override.
                  cellStyleResolver: _cellStyleResolver,
                ),
              ),
            ),

            // — Year view ————————————————————————————————————————————————
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Year view (also supports cellStyleResolver)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: HeatMapCalendar(
                  flexible: true,
                  type: HeatmapCalendarType.year,
                  datasets: _datasets,
                  showColorTip: false,
                  colorTipHelper: const [],
                  colorMode: ColorMode.color,
                  colorsets: const {
                    0: Color(0xFFE0E0E0),
                    1: Color(0xFFBDBDBD),
                  },
                  cellStyleResolver: _cellStyleResolver,
                ),
              ),
            ),

            // — Legend ————————————————————————————————————————————————————
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  _LegendItem(
                      color: Color(0xFF4CAF50), label: 'Income > Expense'),
                  _LegendItem(
                      color: Color(0xFFF44336), label: 'Expense ≥ Income'),
                  _LegendItem(color: Color(0xFFE0E0E0), label: 'No activity'),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
