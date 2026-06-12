## 2.3.0

- Added dynamic-range month view: passing a non-null `endDate` with `type: HeatmapCalendarType.month` renders the exact `startDate..endDate` range week-by-week (e.g. a financial period running `15 Jun → 14 Jul`), instead of falling back to the year heatmap. Fully non-breaking — `endDate` was previously only honored for the year view, so existing month usage is unchanged.
- Fixed `HeatMapCalendar` not reacting to prop changes: it now implements `didUpdateWidget`, so updating `startDate`, `endDate`, or `type` from the parent re-syncs the grid. Previously the reference date was only read once in `initState`, leaving the calendar showing stale dates after a rebuild.
- Fixed opacity normalization for `week` / `biweek` views that cross a month boundary: `maxValue` is now computed from the visible range instead of the base date's calendar month. This removes a potential non-finite alpha (division by zero) crash in `ColorMode.opacity`, plus an extra guard when `maxValue <= 0`.
- Range header (`start – end`) is now also shown for the dynamic-range month, and internal arrow navigation shifts by whole months to keep the period's day-of-month anchors (e.g. `15 → 14`) stable across months of differing length.
- Internal cleanup: generalized the row empty-cell logic to pure week-alignment (supports rows that cross months) and de-duplicated `HeatMapCalendarPage._buildMonthView` to reuse the shared row builder.

## 2.2.0

- Added `cellStyleResolver` (`HeatMapCellStyleResolver`) parameter to `HeatMapCalendar` and `HeatMap`.
- Added `HeatMapCellStyle` class (exported from barrel) with `color` and `textColor` (reserved) fields.
- When `cellStyleResolver` returns a `HeatMapCellStyle` with a non-null `color`, that color takes full priority over the global `colorsets` / `ColorMode` logic for that specific date. Returning `null` falls back to the default threshold-based behavior — fully non-breaking.
- Works for all calendar types: `month`, `week`, `biweek`, and `year`.
- Added `example/lib/pages/heatmap_cell_style_resolver_example.dart` demonstrating a green/red income-vs-expense use case.

## 2.1.0

- Fixed color alignment bug in `HeatMapColumn` for non-default `weekStartsWith` values.
- Fixed null-safety crashes when `spacing` was not explicitly passed to internal widgets.
- Added `type` parameter to `HeatMapCalendar` with `HeatmapCalendarType` enum (`week`, `biweek`, `month`, `year`). Default is `month` — fully non-breaking.
- Added `showText`, `endDate`, `scrollable`, and `reversed` parameters to `HeatMapCalendar`.
- Added `defaultLeftLabel` / `defaultRightLabel` parameters to `HeatMapColorTip` (default `null` — no labels rendered unless provided).

## 2.0.0

- **Breaking change:** Renamed the controller method `gotToDate()` → `goToDate()`.
- Fixed a typo in the method name for clarity and consistency.

## 1.0.0

- Initial release of `heatmap_calendar_plus` (fork of `flutter_heatmap_calendar`).
- Credits: Original work by Kim Seung Hwan (MIT). See `LICENSE`.
- Includes upstream improvements equivalent to `flutter_heatmap_calendar` 1.1.0 (TextStyle props, spacing/layout props, calendar enhancements, docs refresh).
- Package rename, metadata updates (repository, homepage, issue tracker).
- New barrel import: `package:heatmap_calendar_plus/heatmap_calendar_plus.dart`.

---

Upstream history (for reference from the original package):

## 1.0.5

- feat: Created the `onMonthChange` callback on the `HeatMapCalendar`.
- fix: bug where app would have overflow crash if the start date was today.

## 1.0.4

- feat: Add option to customize font size of the month.
- fix: Fixed A Bug With Daylight Savings Resulting In Some Weeks Having 6 Days.

## 1.0.3

- fix: `RangeError` when based day is `Sunday` on `Heatmap`.
- fix: `Wrong month text location error`on `Heatmap`.

## 1.0.2

- Update Package name.
- Update README.md

## 1.0.0

- Initial Open Source.
