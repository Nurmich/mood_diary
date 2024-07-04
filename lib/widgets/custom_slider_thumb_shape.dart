import 'package:flutter/material.dart';

class CustomSliderThumbShape extends RoundSliderThumbShape {
  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double textScaleFactor,
    required double value,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Paint outerCirclePaint = Paint()
      ..color = Colors.grey[50]!
      ..style = PaintingStyle.fill;

    final Paint innerCirclePaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 12.0, outerCirclePaint);

    canvas.drawCircle(center, 6.0, innerCirclePaint);
  }
}
