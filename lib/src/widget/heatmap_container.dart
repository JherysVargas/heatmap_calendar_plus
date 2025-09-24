import 'package:flutter/material.dart';
import '../data/heatmap_color.dart';

class HeatMapContainer extends StatelessWidget {
  final DateTime date;
  final double? size;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? selectedColor;
  final bool? showText;
  final TextStyle? textStyle;
  final Function(DateTime dateTime)? onClick;

  const HeatMapContainer({
    super.key,
    required this.date,
    this.size,
    this.borderRadius,
    this.backgroundColor,
    this.selectedColor,
    this.onClick,
    this.showText,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? HeatMapColor.defaultColor,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 5)),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOutQuad,
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selectedColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 5)),
          ),
          child: (showText ?? true)
              ? Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: const Color(0xFF8A8A8A),
                  ).merge(textStyle),
                )
              : null,
        ),
      ),
      onTap: () => onClick?.call(date),
    );
  }
}
