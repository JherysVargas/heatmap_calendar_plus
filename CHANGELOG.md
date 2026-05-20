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
