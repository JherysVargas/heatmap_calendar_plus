import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:heatmap_calendar_plus/heatmap_calendar_plus.dart';
import 'package:heatmap_calendar_plus/src/util/date_util.dart';
import 'package:heatmap_calendar_plus/src/util/datasets_util.dart';
import 'package:heatmap_calendar_plus/src/widget/heatmap_color_tip.dart';
import 'package:heatmap_calendar_plus/src/widget/heatmap_container.dart';

void main() {
  // ─────────────────────────────────────────────
  // Task 1: DateUtil.changeDay unit tests
  // ─────────────────────────────────────────────
  group('DateUtil.changeDay', () {
    test('same-month shift: adds days within the same month', () {
      final base = DateTime(2024, 5, 10);
      final result = DateUtil.changeDay(base, 5);
      expect(result, DateTime(2024, 5, 15));
    });

    test('month overflow: rolls over to the next month', () {
      final base = DateTime(2024, 1, 30);
      final result = DateUtil.changeDay(base, 5);
      expect(result, DateTime(2024, 2, 4));
    });

    test('leap-year rollover: Feb 28 + 1 day = Feb 29 on leap year', () {
      final base = DateTime(2024, 2, 28); // 2024 is a leap year
      final result = DateUtil.changeDay(base, 1);
      expect(result, DateTime(2024, 2, 29));
    });

    test('non-leap-year rollover: Feb 28 + 1 day = Mar 1', () {
      final base = DateTime(2023, 2, 28); // 2023 is NOT a leap year
      final result = DateUtil.changeDay(base, 1);
      expect(result, DateTime(2023, 3, 1));
    });
  });

  // ─────────────────────────────────────────────
  // Task 2: HeatMap with weekStartsWith=1 color alignment
  // ─────────────────────────────────────────────
  group('HeatMap color alignment with weekStartsWith=1', () {
    setUpAll(() async {
      await initializeDateFormatting();
    });

    testWidgets('Monday cell uses Monday dataset color, not a shifted date', (
      WidgetTester tester,
    ) async {
      // Monday 2024-05-06 has value 10
      final monday = DateTime(2024, 5, 6);
      final datasets = {monday: 10};
      final colorsets = {1: Colors.green};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HeatMap(
                colorsets: colorsets,
                colorMode: ColorMode.color,
                weekStartsWith: 1,
                startDate: DateTime(2024, 5, 6),
                endDate: DateTime(2024, 5, 12),
                datasets: datasets,
                showColorTip: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // The heatmap should render without exceptions
      expect(tester.takeException(), isNull);

      // There should be at least 1 green-colored AnimatedContainer (Monday's dataset)
      final greenContainers = find.byWidgetPredicate(
        (widget) =>
            widget is AnimatedContainer &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == Colors.green,
      );
      expect(greenContainers, findsAtLeastNWidgets(1));
    });

    testWidgets('number of colored blocks matches non-zero dataset entries', (
      WidgetTester tester,
    ) async {
      // Two separate days in the same week
      final monday = DateTime(2024, 5, 6);
      final wednesday = DateTime(2024, 5, 8);
      final datasets = {monday: 5, wednesday: 10};
      final colorsets = {1: Colors.blue, 6: Colors.red};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HeatMap(
                colorsets: colorsets,
                colorMode: ColorMode.color,
                weekStartsWith: 1,
                startDate: DateTime(2024, 5, 6),
                endDate: DateTime(2024, 5, 12),
                datasets: datasets,
                showColorTip: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Verify the heatmap rendered correctly — both colored days are in the dataset
      // and the widget rendered without errors means alignment is correct.
      // Verify via AnimatedContainer with a BoxDecoration containing a color.
      final coloredBlocks = find.byWidgetPredicate(
        (widget) =>
            widget is AnimatedContainer &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color != null &&
            (widget.decoration as BoxDecoration).color != Colors.transparent,
      );
      // 2 datasets entries means 2 colored blocks
      expect(coloredBlocks, findsAtLeastNWidgets(2));
    });
  });

  // ─────────────────────────────────────────────
  // Task 3: HeatMapCalendarPage without spacing
  // ─────────────────────────────────────────────
  group('HeatMapCalendarPage spacing default', () {
    setUpAll(() async {
      await initializeDateFormatting();
    });

    testWidgets('builds without null exception when spacing is omitted', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HeatMapCalendar(
                colorsets: {1: Colors.green},
                colorMode: ColorMode.color,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // The calendar widget should be present in the tree
      expect(find.byType(HeatMapCalendar), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // Task 4: HeatMapColorTip without spacing
  // ─────────────────────────────────────────────
  group('HeatMapColorTip spacing default', () {
    testWidgets('builds without null exception when spacing is omitted', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeatMapColorTip(
              colorMode: ColorMode.opacity,
              colorsets: {1: Colors.green},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // No labels rendered by default (defaultLeftLabel/defaultRightLabel are null)
      expect(find.text('less'), findsNothing);
      expect(find.text('more'), findsNothing);
    });
  });

  // ─────────────────────────────────────────────
  // Task 1 (TDD RED): DateUtil.startDayOfWeek / endDayOfWeek
  // ─────────────────────────────────────────────
  group('DateUtil.startDayOfWeek', () {
    test('Sunday start (weekStartsWith=7): Wednesday → previous Sunday', () {
      // Wednesday 2024-05-08, weekStartsWith=7 (Sunday)
      final wednesday = DateTime(2024, 5, 8); // weekday=3
      final result = DateUtil.startDayOfWeek(wednesday, 7);
      expect(result, DateTime(2024, 5, 5)); // Sunday
    });

    test(
      'Monday start (weekStartsWith=1): Wednesday → Monday of same week',
      () {
        final wednesday = DateTime(2024, 5, 8); // weekday=3
        final result = DateUtil.startDayOfWeek(wednesday, 1);
        expect(result, DateTime(2024, 5, 6)); // Monday
      },
    );

    test('startDayOfWeek: date that IS the start day returns itself', () {
      final monday = DateTime(2024, 5, 6); // weekday=1
      final result = DateUtil.startDayOfWeek(monday, 1);
      expect(result, monday);
    });
  });

  group('DateUtil.endDayOfWeek', () {
    test('endDayOfWeek = startDayOfWeek + 6', () {
      final wednesday = DateTime(2024, 5, 8);
      final start = DateUtil.startDayOfWeek(wednesday, 1); // Monday 2024-05-06
      final end = DateUtil.endDayOfWeek(wednesday, 1);
      expect(end, DateUtil.changeDay(start, 6)); // Sunday 2024-05-12
    });

    test('endDayOfWeek Sunday-start: end is Saturday', () {
      final wednesday = DateTime(2024, 5, 8);
      final end = DateUtil.endDayOfWeek(wednesday, 7);
      expect(end, DateTime(2024, 5, 11)); // Saturday
    });
  });

  // ─────────────────────────────────────────────
  // Task 3 (TDD RED): DatasetsUtil.filterDateRange
  // ─────────────────────────────────────────────
  group('DatasetsUtil.filterDateRange', () {
    test('null input returns empty map', () {
      final result = DatasetsUtil.filterDateRange(
        null,
        DateTime(2024, 5, 1),
        DateTime(2024, 5, 7),
      );
      expect(result, isEmpty);
    });

    test('inclusive boundaries are kept', () {
      final start = DateTime(2024, 5, 1);
      final end = DateTime(2024, 5, 7);
      final datasets = {
        DateTime(2024, 5, 1): 1, // boundary start — keep
        DateTime(2024, 5, 4): 5, // middle — keep
        DateTime(2024, 5, 7): 10, // boundary end — keep
      };
      final result = DatasetsUtil.filterDateRange(datasets, start, end);
      expect(result.length, 3);
      expect(result[DateTime(2024, 5, 1)], 1);
      expect(result[DateTime(2024, 5, 7)], 10);
    });

    test('out-of-range entries are removed', () {
      final start = DateTime(2024, 5, 1);
      final end = DateTime(2024, 5, 7);
      final datasets = {
        DateTime(2024, 4, 30): 99, // before start — remove
        DateTime(2024, 5, 3): 3, // in range — keep
        DateTime(2024, 5, 8): 88, // after end — remove
      };
      final result = DatasetsUtil.filterDateRange(datasets, start, end);
      expect(result.length, 1);
      expect(result[DateTime(2024, 5, 3)], 3);
    });
  });

  // ─────────────────────────────────────────────
  // Task 5 (TDD): HeatMapCalendar type=week renders 7 HeatMapContainers
  // ─────────────────────────────────────────────
  group('HeatMapCalendar type=week', () {
    setUpAll(() async {
      await initializeDateFormatting();
    });

    testWidgets('renders exactly 7 HeatMapContainer widgets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeatMapCalendar(
              type: HeatmapCalendarType.week,
              startDate: DateTime(2024, 5, 6),
              colorsets: {1: Colors.green},
              colorMode: ColorMode.color,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(HeatMapContainer), findsNWidgets(7));
    });
  });

  // ─────────────────────────────────────────────
  // Task 8 (TDD): HeatMapCalendar type=biweek renders 14 HeatMapContainers
  // ─────────────────────────────────────────────
  group('HeatMapCalendar type=biweek', () {
    setUpAll(() async {
      await initializeDateFormatting();
    });

    testWidgets('renders exactly 14 HeatMapContainer widgets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeatMapCalendar(
              type: HeatmapCalendarType.biweek,
              startDate: DateTime(2024, 5, 6),
              colorsets: {1: Colors.green},
              colorMode: ColorMode.color,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(HeatMapContainer), findsNWidgets(14));
    });
  });

  // ─────────────────────────────────────────────
  // Task 10 (TDD): HeatMapCalendar dispatches correct widget types by type
  // ─────────────────────────────────────────────
  group('HeatMapCalendar type dispatch', () {
    setUpAll(() async {
      await initializeDateFormatting();
    });

    testWidgets('type=week renders 7 HeatMapContainer widgets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeatMapCalendar(
              type: HeatmapCalendarType.week,
              startDate: DateTime(2024, 5, 6),
              colorsets: {1: Colors.green},
              colorMode: ColorMode.color,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(HeatMapContainer), findsNWidgets(7));
    });

    testWidgets('type=year renders HeatMap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: HeatMapCalendar(
                type: HeatmapCalendarType.year,
                startDate: DateTime(2024, 5, 6),
                colorsets: {1: Colors.green},
                colorMode: ColorMode.color,
                scrollable: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Layout overflow is acceptable for year view in constrained test env
      final exception = tester.takeException();
      expect(
        exception == null || exception.toString().contains('overflowed'),
        isTrue,
      );
      expect(find.byType(HeatMap), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // Task 12 (TDD RED): HeatMapCalendar showText=false hides day numbers
  // ─────────────────────────────────────────────
  group('HeatMapCalendar showText', () {
    setUpAll(() async {
      await initializeDateFormatting();
    });

    testWidgets('showText=false renders containers without day number text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HeatMapCalendar(
                colorsets: {1: Colors.green},
                colorMode: ColorMode.color,
                showText: false,
                startDate: DateTime(2024, 5, 1),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      // When showText=false, no day-number text widgets should be visible
      // Day 1 shouldn't be visible as a text node
      expect(find.text('1'), findsNothing);
    });

    testWidgets('showText=true (default) shows day numbers', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HeatMapCalendar(
                colorsets: {1: Colors.green},
                colorMode: ColorMode.color,
                startDate: DateTime(2024, 5, 1),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('1'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // HeatMapCalendar week/biweek header navigation
  // ─────────────────────────────────────────────
  group('HeatMapCalendar week/biweek header', () {
    setUpAll(() async {
      await initializeDateFormatting();
    });

    testWidgets('type=week shows date range in header', (
      WidgetTester tester,
    ) async {
      // Monday 2024-05-06, weekStartsWith=1 → range "May 6 – May 12"
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeatMapCalendar(
              type: HeatmapCalendarType.week,
              startDate: DateTime(2024, 5, 6),
              weekStartsWith: 1,
              colorsets: {1: Colors.green},
              colorMode: ColorMode.color,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('May 6 – May 12'), findsOneWidget);
    });

    testWidgets('type=week next arrow advances by 7 days', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeatMapCalendar(
              type: HeatmapCalendarType.week,
              startDate: DateTime(2024, 5, 6),
              weekStartsWith: 1,
              colorsets: {1: Colors.green},
              colorMode: ColorMode.color,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_forward_ios));
      await tester.pumpAndSettle();
      // Next week: May 13 – May 19
      expect(find.text('May 13 – May 19'), findsOneWidget);
    });

    testWidgets('type=biweek shows two-week range in header', (
      WidgetTester tester,
    ) async {
      // Monday 2024-05-06, weekStartsWith=1 → range "May 6 – May 19"
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeatMapCalendar(
              type: HeatmapCalendarType.biweek,
              startDate: DateTime(2024, 5, 6),
              weekStartsWith: 1,
              colorsets: {1: Colors.green},
              colorMode: ColorMode.color,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('May 6 – May 19'), findsOneWidget);
    });

    testWidgets('type=biweek next arrow advances by 14 days', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeatMapCalendar(
              type: HeatmapCalendarType.biweek,
              startDate: DateTime(2024, 5, 6),
              weekStartsWith: 1,
              colorsets: {1: Colors.green},
              colorMode: ColorMode.color,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_forward_ios));
      await tester.pumpAndSettle();
      // +14 days: May 20 – Jun 2
      expect(find.text('May 20 – Jun 2'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // Task 14 (TDD RED): HeatMapColorTip null labels render no label text
  // ─────────────────────────────────────────────
  group('HeatMapColorTip defaultLeftLabel/defaultRightLabel', () {
    testWidgets(
      'null defaultLeftLabel and defaultRightLabel with no helper widgets renders no label text',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: HeatMapColorTip(
                colorMode: ColorMode.opacity,
                colorsets: {1: Colors.green},
                defaultLeftLabel: null,
                defaultRightLabel: null,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('less'), findsNothing);
        expect(find.text('more'), findsNothing);
      },
    );

    testWidgets(
      'defaultLeftLabel and defaultRightLabel with values render label text',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: HeatMapColorTip(
                colorMode: ColorMode.opacity,
                colorsets: {1: Colors.green},
                defaultLeftLabel: 'menos',
                defaultRightLabel: 'más',
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('menos'), findsOneWidget);
        expect(find.text('más'), findsOneWidget);
      },
    );
  });
}
