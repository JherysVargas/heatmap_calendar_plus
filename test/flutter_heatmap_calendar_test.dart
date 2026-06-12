import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:heatmap_calendar_plus/heatmap_calendar_plus.dart';
import 'package:heatmap_calendar_plus/src/util/date_util.dart';
import 'package:heatmap_calendar_plus/src/util/datasets_util.dart';
import 'package:heatmap_calendar_plus/src/widget/heatmap_color_tip.dart';
import 'package:heatmap_calendar_plus/src/widget/heatmap_container.dart';

void main() {
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
      final base = DateTime(2024, 2, 28);
      final result = DateUtil.changeDay(base, 1);
      expect(result, DateTime(2024, 2, 29));
    });

    test('non-leap-year rollover: Feb 28 + 1 day = Mar 1', () {
      final base = DateTime(2023, 2, 28);
      final result = DateUtil.changeDay(base, 1);
      expect(result, DateTime(2023, 3, 1));
    });
  });

  group('HeatMap color alignment with weekStartsWith=1', () {
    setUpAll(() async {
      await initializeDateFormatting();
    });

    testWidgets('Monday cell uses Monday dataset color, not a shifted date', (
      WidgetTester tester,
    ) async {
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

      expect(tester.takeException(), isNull);

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

      final coloredBlocks = find.byWidgetPredicate(
        (widget) =>
            widget is AnimatedContainer &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color != null &&
            (widget.decoration as BoxDecoration).color != Colors.transparent,
      );

      expect(coloredBlocks, findsAtLeastNWidgets(2));
    });
  });

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

      expect(find.byType(HeatMapCalendar), findsOneWidget);
    });
  });

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

      expect(find.text('less'), findsNothing);
      expect(find.text('more'), findsNothing);
    });
  });

  group('DateUtil.startDayOfWeek', () {
    test('Sunday start (weekStartsWith=7): Wednesday → previous Sunday', () {
      final wednesday = DateTime(2024, 5, 8);
      final result = DateUtil.startDayOfWeek(wednesday, 7);
      expect(result, DateTime(2024, 5, 5));
    });

    test(
      'Monday start (weekStartsWith=1): Wednesday → Monday of same week',
      () {
        final wednesday = DateTime(2024, 5, 8);
        final result = DateUtil.startDayOfWeek(wednesday, 1);
        expect(result, DateTime(2024, 5, 6));
      },
    );

    test('startDayOfWeek: date that IS the start day returns itself', () {
      final monday = DateTime(2024, 5, 6);
      final result = DateUtil.startDayOfWeek(monday, 1);
      expect(result, monday);
    });
  });

  group('DateUtil.endDayOfWeek', () {
    test('endDayOfWeek = startDayOfWeek + 6', () {
      final wednesday = DateTime(2024, 5, 8);
      final start = DateUtil.startDayOfWeek(wednesday, 1);
      final end = DateUtil.endDayOfWeek(wednesday, 1);
      expect(end, DateUtil.changeDay(start, 6));
    });

    test('endDayOfWeek Sunday-start: end is Saturday', () {
      final wednesday = DateTime(2024, 5, 8);
      final end = DateUtil.endDayOfWeek(wednesday, 7);
      expect(end, DateTime(2024, 5, 11));
    });
  });

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
        DateTime(2024, 5, 1): 1,
        DateTime(2024, 5, 4): 5,
        DateTime(2024, 5, 7): 10,
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
        DateTime(2024, 4, 30): 99,
        DateTime(2024, 5, 3): 3,
        DateTime(2024, 5, 8): 88,
      };
      final result = DatasetsUtil.filterDateRange(datasets, start, end);
      expect(result.length, 1);
      expect(result[DateTime(2024, 5, 3)], 3);
    });
  });

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

      final exception = tester.takeException();
      expect(
        exception == null || exception.toString().contains('overflowed'),
        isTrue,
      );
      expect(find.byType(HeatMap), findsOneWidget);
    });
  });

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

  group('HeatMapCalendar week/biweek header', () {
    setUpAll(() async {
      await initializeDateFormatting();
    });

    testWidgets('type=week shows date range in header', (
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

      expect(find.text('May 13 – May 19'), findsOneWidget);
    });

    testWidgets('type=biweek shows two-week range in header', (
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

      expect(find.text('May 20 – Jun 2'), findsOneWidget);
    });
  });

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

  group('DateUtil.separatedRange', () {
    test('financial period 15 Jun → 14 Jul (weekStartsWith=1)', () {
      final rows = DateUtil.separatedRange(
        DateTime(2026, 6, 15),
        DateTime(2026, 7, 14),
        1,
      );
      expect(rows, [
        {DateTime(2026, 6, 15): DateTime(2026, 6, 21)},
        {DateTime(2026, 6, 22): DateTime(2026, 6, 28)},
        {DateTime(2026, 6, 29): DateTime(2026, 7, 5)},
        {DateTime(2026, 7, 6): DateTime(2026, 7, 12)},
        {DateTime(2026, 7, 13): DateTime(2026, 7, 14)},
      ]);
    });

    test('first/last rows align to weekStartsWith — 20 May → 19 Jun', () {
      final rows = DateUtil.separatedRange(
        DateTime(2026, 5, 20),
        DateTime(2026, 6, 19),
        1,
      );
      expect(rows, [
        {DateTime(2026, 5, 20): DateTime(2026, 5, 24)},
        {DateTime(2026, 5, 25): DateTime(2026, 5, 31)},
        {DateTime(2026, 6, 1): DateTime(2026, 6, 7)},
        {DateTime(2026, 6, 8): DateTime(2026, 6, 14)},
        {DateTime(2026, 6, 15): DateTime(2026, 6, 19)},
      ]);
    });

    test('parity: full calendar month equals separatedMonth', () {
      final range = DateUtil.separatedRange(
        DateTime(2026, 6, 1),
        DateTime(2026, 6, 30),
        1,
      );
      expect(range, DateUtil.separatedMonth(DateTime(2026, 6, 1), 1));
    });

    test('parity: month not starting on weekStart (Sep 2026)', () {
      final range = DateUtil.separatedRange(
        DateTime(2026, 9, 1),
        DateTime(2026, 9, 30),
        1,
      );
      expect(range, DateUtil.separatedMonth(DateTime(2026, 9, 1), 1));
    });

    test('single-day range yields one single-day row', () {
      final rows = DateUtil.separatedRange(
        DateTime(2026, 6, 15),
        DateTime(2026, 6, 15),
        1,
      );
      expect(rows, [
        {DateTime(2026, 6, 15): DateTime(2026, 6, 15)},
      ]);
    });

    test('leap February ends exactly on Feb 29', () {
      final rows = DateUtil.separatedRange(
        DateTime(2024, 2, 1),
        DateTime(2024, 2, 29),
        1,
      );
      expect(rows.last.values.first, DateTime(2024, 2, 29));
    });

    test('time components on the bounds are ignored', () {
      final rows = DateUtil.separatedRange(
        DateTime(2026, 6, 15, 8, 30),
        DateTime(2026, 7, 14, 23, 59, 59),
        1,
      );
      expect(rows.first.keys.first, DateTime(2026, 6, 15));
      expect(rows.last.values.first, DateTime(2026, 7, 14));
    });
  });

  group('HeatMapCalendar month + endDate (range mode)', () {
    setUpAll(() async {
      await initializeDateFormatting();
    });

    Widget rangeCalendar({Function(DateTime)? onClick}) => MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: HeatMapCalendar(
            type: HeatmapCalendarType.month,
            startDate: DateTime(2026, 6, 15),
            endDate: DateTime(2026, 7, 14),
            weekStartsWith: 1,
            colorsets: const {1: Colors.green},
            colorMode: ColorMode.color,
            onClick: onClick,
          ),
        ),
      ),
    );

    testWidgets('renders exactly one container per day in the range', (
      tester,
    ) async {
      await tester.pumpWidget(rangeCalendar());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      expect(find.byType(HeatMapContainer), findsNWidgets(30));
    });

    testWidgets('shows period bounds and the cross-month day once', (
      tester,
    ) async {
      await tester.pumpWidget(rangeCalendar());
      await tester.pumpAndSettle();
      expect(find.text('15'), findsOneWidget);
      expect(find.text('14'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('header shows the period range', (tester) async {
      await tester.pumpWidget(rangeCalendar());
      await tester.pumpAndSettle();
      expect(find.text('Jun 15 – Jul 14'), findsOneWidget);
    });

    testWidgets('next arrow shifts by a whole month, keeping day anchors', (
      tester,
    ) async {
      await tester.pumpWidget(rangeCalendar());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_forward_ios));
      await tester.pumpAndSettle();

      expect(find.text('Jul 15 – Aug 14'), findsOneWidget);
    });

    testWidgets(
      'back navigation keeps the 15th anchor across months of differing length',
      (tester) async {
        await tester.pumpWidget(rangeCalendar());
        await tester.pumpAndSettle();

        const expected = [
          'May 15 – Jun 14',
          'Apr 15 – May 14',
          'Mar 15 – Apr 14',
          'Feb 15 – Mar 14',
          'Jan 15 – Feb 14',
        ];
        for (final label in expected) {
          await tester.tap(find.byIcon(Icons.arrow_back_ios));
          await tester.pumpAndSettle();
          expect(find.text(label), findsOneWidget);
        }
      },
    );

    testWidgets('tapping a cell reports the correct date', (tester) async {
      DateTime? clicked;
      await tester.pumpWidget(rangeCalendar(onClick: (d) => clicked = d));
      await tester.pumpAndSettle();
      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();
      expect(clicked, DateTime(2026, 7, 1));
    });
  });

  group('HeatMapCalendar month without endDate', () {
    setUpAll(() async {
      await initializeDateFormatting();
    });

    testWidgets('renders one container per day of the calendar month', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HeatMapCalendar(
                type: HeatmapCalendarType.month,
                startDate: DateTime(2026, 6, 1),
                weekStartsWith: 1,
                colorsets: const {1: Colors.green},
                colorMode: ColorMode.color,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      expect(find.byType(HeatMapContainer), findsNWidgets(30));
    });
  });

  group('HeatMapCalendar didUpdateWidget resync', () {
    setUpAll(() async {
      await initializeDateFormatting();
    });

    Widget build(HeatmapCalendarType type, DateTime startDate) => MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: HeatMapCalendar(
            type: type,
            startDate: startDate,
            weekStartsWith: 1,
            colorsets: const {1: Colors.green},
            colorMode: ColorMode.color,
          ),
        ),
      ),
    );

    testWidgets('changing startDate/type updates the rendered days', (
      tester,
    ) async {
      await tester.pumpWidget(
        build(HeatmapCalendarType.month, DateTime(2026, 6, 1)),
      );
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        build(HeatmapCalendarType.week, DateTime(2026, 6, 8)),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      for (final day in [8, 9, 10, 11, 12, 13, 14]) {
        expect(find.text('$day'), findsOneWidget);
      }
      expect(find.text('1'), findsNothing);
    });
  });

  group('HeatMapCalendar opacity maxValue across month boundary', () {
    setUpAll(() async {
      await initializeDateFormatting();
    });

    testWidgets('week crossing a month with data only in the other month', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HeatMapCalendar(
                type: HeatmapCalendarType.week,
                startDate: DateTime(2026, 7, 1),
                weekStartsWith: 1,
                colorMode: ColorMode.opacity,
                colorsets: const {1: Colors.green},
                datasets: {DateTime(2026, 6, 30): 10},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
