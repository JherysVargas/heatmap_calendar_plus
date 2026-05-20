import 'package:flutter/material.dart';

/// Defines the visual style applied to an individual heatmap cell.
///
/// When provided via [HeatMapCellStyleResolver], the resolved style takes
/// full priority over the global [colorsets] / [ColorMode] logic for that
/// specific date. Returning `null` (or a style with `color: null`) falls back
/// to the default threshold-based coloring.
class HeatMapCellStyle {
  /// Background color of the cell.
  ///
  /// If `null`, the cell falls back to the global [colorsets] logic.
  final Color? color;

  /// Text color of the day number inside the cell.
  ///
  /// Reserved for future use. Not yet applied by the package renderer.
  final Color? textColor;

  const HeatMapCellStyle({this.color, this.textColor});
}

/// A callback that resolves the style of a single heatmap cell by its date.
///
/// Return a [HeatMapCellStyle] with a non-null [HeatMapCellStyle.color] to
/// override the default threshold-based color for that day. Return `null` (or
/// a style with `color: null`) to let the heatmap fall back to its normal
/// [colorsets] / [ColorMode] behavior.
///
/// Example — color cells green when income > expense, red otherwise:
/// ```dart
/// cellStyleResolver: (date) {
///   final income = getIncome(date);
///   final expense = getExpense(date);
///   if (income == 0 && expense == 0) return null;
///   return HeatMapCellStyle(
///     color: income > expense ? Colors.green : Colors.red,
///   );
/// },
/// ```
typedef HeatMapCellStyleResolver = HeatMapCellStyle? Function(DateTime date);
