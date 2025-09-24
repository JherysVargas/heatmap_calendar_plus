# Heatmap Calendar Plus (fork)

This package is an actively maintained fork of flutter_heatmap_calendar, inspired by GitHub’s contribution graph.

- Original package: https://pub.dev/packages/flutter_heatmap_calendar
- Original author: Kim Seung Hwan (MIT)

Heatmap Calendar Plus maintains compatibility with the existing API and continues with bug fixes and new features. It provides the traditional HeatMap widget as well as its calendar version `HeatMapCalendar`.

### Migración desde `flutter_heatmap_calendar`

1. Update your `pubspec.yaml` to use this fork:

```yaml
dependencies:
  heatmap_calendar_plus: ^1.0.0
```

2. Update your imports:

```diff
- import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
+ import 'package:heatmap_calendar_plus/heatmap_calendar_plus.dart';
```

![HeatMap](https://user-images.githubusercontent.com/4322099/147415928-76ed96fa-5a95-4a61-abec-01f32874c795.gif)
![HeatMapCalendar](https://user-images.githubusercontent.com/4322099/147415931-25596f1f-e3ab-47fb-a375-8384acdf8d09.gif)

## 🔥 Why use this fork

- Actively maintained: keeps evolving with fixes, improvements, and support for modern Flutter/Dart (Dart 3 compatible).
- Smooth migration: almost drop-in replacement with a dedicated migration section and barrel import (`heatmap_calendar_plus.dart`).
- API modernization: consolidated TextStyle-based props (`monthTextStyle`, `weekTextStyle`, `dayTextStyle`) and clearer spacing controls (`blockSpacing`, `colorTipSpacing`).
- More control on calendar: header customization via `headerBuilder`, header margin with `marginHeader`, and a `HeatMapCalendarController` for programmatic control.
- Stability fixes: includes upstream fixes (overflow with startDate, DST week alignment) and general refactors.
- Better docs and example: refreshed README and runnable example app.
- Localization-ready: month and week labels adapt to your app locale (uses `intl`); the example includes `flutter_localizations`.

## ✨ Features

- Two widgets: `HeatMap` (contribution grid) and `HeatMapCalendar` (calendar view).
- Color strategies: `ColorMode.opacity` and `ColorMode.color` with threshold-based `colorsets`.
- Customization: `size`, `blockSpacing`, `borderRadius`, `scrollable`/`flexible`, `monthTextStyle`, `weekTextStyle`, `dayTextStyle`.
- Interactivity: `onClick` on days and `onMonthChange` on month navigation.
- Calendar-specific add-ons:
  - `headerBuilder` for a custom header UI.
  - `marginHeader` to tweak header spacing.
  - `HeatMapCalendarController` for programmatic navigation/control.
- Localization (i18n): month/week labels localized via `intl` following your `MaterialApp` locale.

## 🌍 Localization (i18n)

`heatmap_calendar_plus` utiliza `intl` para mostrar nombres de meses y etiquetas de semana según el locale de tu aplicación. Asegúrate de habilitar las localizaciones de Flutter:

```dart
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
  // Usa los delegados por defecto de Flutter
  localizationsDelegates: GlobalMaterialLocalizations.delegates,

  // Declara los locales soportados por tu app
  supportedLocales: const [
    Locale('en'),
    Locale('es'),
    // agrega tus locales...
  ],

  // Opcional: fuerza un locale específico durante pruebas/desarrollo
  locale: const Locale('es'),
  // ...
)
```

El ejemplo incluido en `example/` ya viene configurado con `flutter_localizations` y `supportedLocales` para `es` y `en`.

## 📦 Getting started

### Depend on it.

```
flutter pub add heatmap_calendar_plus
```

**or**

Add below line to your personal package's `pubspec.yaml`.

```yaml
dependencies:
  heatmap_calendar_plus: ^1.0.0
```

And run `flutter pub get` to install.

### Import it.

```dart
import 'package:heatmap_calendar_plus/heatmap_calendar_plus.dart';
```

## Props

### HeatMap

<!-- prettier-ignore -->
|Props|Types|Default|Description|
|-|-|-|-|
|startDate|`DateTime?`|1 year before of the `endDate`|Start date of `HeatMap`.|
|endDate|`DateTime?`|Today<br>( `DateTime.now()` )|Last day of `HeatMap`.|
|datasets|`Map<DateTime, int>?`|`null`|Sets of data which to be displayed.|
|colorsets|`Map<int, Color>`|required|Sets of color values for its thresholds key value.<br>At least one Color is required.<br>Be aware that only first color will be used if `ColorMode` is `ColorMode.opacity`.|
|defaultColor|`Color?`|`null`|Default color of every block.|
|monthTextStyle|`TextStyle?`|`null`|The TextStyle of month header.|
|weekTextStyle|`TextStyle?`|`null`|The TextStyle of week labels.|
|dayTextStyle|`TextStyle?`|`null`|The TextStyle of day number in each block.|
|colorMode|`ColorMode`|`ColorMode.opacity`|`ColorMode.opacity` requires just one colorsets value and changes color dynamically based on hightest value of `datasets`.<br>`ColorMode.color` changes colors based on `colorsets` thresholds key value.|
|size|`double?`|`20`|The size of every block.|
|onClick|`Function(DateTime)?`|`null`|Callback function which will be called if user clicks the block.|
|blockSpacing|`double`|`6.0`|The spacing value for every block.|
|borderRadius|`double?`|`null`|Border radius value of block.|
|scrollable|`bool`|`false`|Make `HeatMap` scrollable if `scrollable` is `true`.|
|showText|`bool`|`false`|Show day text in every block if `showText` is `true`.|
|showColorTip|`bool`|`true`|Show color tip if `showColorTip` is `true`.|
|colorTipHelper|`List<Widget?>?`|`null`|Widgets which are shown at left and right side of `colorTip`.<br>First value is the left side widget and second value is the right side widget.<br>Give null value makes default 'less' and 'more' text.|
|colorTipCount|`int?`|`null`|Length of `colorTip` block.|
|colorTipSize|`double?`|`null`|The size of `colorTip`.|
|colorTipSpacing|`double`|`6.0`|The spacing value between tip containers and left/right widgets.|

### HeatMapCalendar

<!-- prettier-ignore -->
|Props|Types|Default|Description|
|-|-|---|-|
|initDate|`DateTime?`|Today<br>( `DateTime.now()` )|Initialized Year/Month value of `HeatMapCalendar`.|
|datasets|`Map<DateTime, int>?`|`null`|Sets of data which to be displayed.|
|colorsets|`Map<int, Color>`|required|Sets of color values for its thresholds key value.<br>At least one Color is required.<br>Be aware that only first color will be used if `ColorMode` is `ColorMode.opacity`.|
|defaultColor|`Color?`|`null`|Default color of every block.|
|textColor|`Color?`|`null`|Color value of every text.|
|colorMode|`ColorMode`|`ColorMode.opacity`|`ColorMode.opacity` requires just one colorsets value and changes color dynamically based on hightest value of `datasets`.<br>`ColorMode.color` changes colors based on `colorsets` thresholds key value.|
|size|`double?`|`42`|The size of every block.|
|fontSize|`double?`|`null`|The size of every text.|
|monthTextStyle|`TextStyle?`|`null`|The TextStyle of month header.|
|weekTextStyle|`TextStyle?`|`null`|The TextStyle of week labels.|
|dayTextStyle|`TextStyle?`|`null`|The TextStyle of day number in each block.|
|onClick|`Function(DateTime)?`|`null`|Callback function which will be called if user clicks the block.|
|onMonthChange|`Function(DateTime)?`|`null`|Callback function which will be called when month is changed.|
|borderRadius|`double?`|`null`|Border radius value of block.|
|flexible|`bool`|`false`|Makes `HeatMapCalendar`'s size dynamically fit on screen.<br>If `flexible` is `true` then, `size` props will be ignored.|
|blockSpacing|`double`|`6.0`|The spacing value for every block.|
|showColorTip|`bool`|`true`|Show color tip if `showColorTip` is `true`.|
|colorTipHelper|`List<Widget?>?`|`null`|Widgets which are shown at left and right side of `colorTip`.<br>First value is the left side widget and second value is the right side widget.<br>Give null value makes default 'less' and 'more' text.|
|colorTipCount|`int?`|`null`|Length of `colorTip` block.|
|colorTipSize|`double?`|`null`|The size of `colorTip`.|
|colorTipSpacing|`double`|`6.0`|The spacing value between tip containers and left/right widgets.|
|marginHeader|`EdgeInsets?`|`null`|The EdgeInsets value of margin for header.|
|headerBuilder|`HeaderBuilder?`|`null`|Custom header builder function.|
|controller|`HeatMapCalendarController?`|`null`|Controller for manipulating the state of `HeatMapCalendar`.|

## Example

### HeatMap

```dart
import 'package:heatmap_calendar_plus/heatmap_calendar_plus.dart';
...
HeatMap(
  datasets: {
    DateTime(2021, 1, 6): 3,
    DateTime(2021, 1, 7): 7,
    DateTime(2021, 1, 8): 10,
    DateTime(2021, 1, 9): 13,
    DateTime(2021, 1, 13): 6,
  },
  colorMode: ColorMode.opacity,
  showText: false,
  scrollable: true,
  colorsets: {
    1: Colors.red,
    3: Colors.orange,
    5: Colors.yellow,
    7: Colors.green,
    9: Colors.blue,
    11: Colors.indigo,
    13: Colors.purple,
  },
  onClick: (value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
  },
);
```

### HeatMapCalendar

```dart
import 'package:heatmap_calendar_plus/heatmap_calendar_plus.dart';
...
HeatMapCalendar(
  defaultColor: Colors.white,
  flexible: true,
  colorMode: ColorMode.color,
  datasets: {
    DateTime(2021, 1, 6): 3,
    DateTime(2021, 1, 7): 7,
    DateTime(2021, 1, 8): 10,
    DateTime(2021, 1, 9): 13,
    DateTime(2021, 1, 13): 6,
  },
  colorsets: const {
    1: Colors.red,
    3: Colors.orange,
    5: Colors.yellow,
    7: Colors.green,
    9: Colors.blue,
    11: Colors.indigo,
    13: Colors.purple,
  },
  onClick: (value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
  },
);
```

## License

Este proyecto es un fork bajo licencia MIT del trabajo original de Kim Seung Hwan. Consulta el archivo `LICENSE` para los avisos completos.
