import 'package:flutter/material.dart';

class WidgetUtil {
  /// Make [HeatMapContainer] flexible size if [isFlexible] is true.
  static Widget flexibleContainer({
    required bool isFlexible,
    required Widget child,
    bool isSquare = false,
  }) {
    return isFlexible
        ? Expanded(
            child: isSquare ? AspectRatio(aspectRatio: 1, child: child) : child,
          )
        : child;
  }
}
