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
