## 1.1.0

- **BREAKING CHANGE**: Removed deprecated props and replaced with new TextStyle-based props:
  - Removed `textColor`, `fontSize` from `HeatMap`
  - Removed `monthFontSize`, `weekFontSize`, `weekTextColor` from `HeatMapCalendar`
  - Removed `margin` prop from both widgets
- feat: Added comprehensive TextStyle support:
  - Added `monthTextStyle`, `weekTextStyle`, `dayTextStyle` props to both `HeatMap` and `HeatMapCalendar`
- feat: Added new spacing and layout props:
  - Added `blockSpacing` prop to replace old margin system
  - Added `colorTipSpacing` prop for better color tip control
- feat: Added `HeatMapCalendar` enhancements:
  - Added `marginHeader` prop for header margin control
  - Added `headerBuilder` prop for custom header implementation
  - Added `controller` prop (`HeatMapCalendarController`) for programmatic control
- refactor: Improved default values and removed hard-coded color references
- docs: Updated README.md with current props and removed obsolete documentation

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
