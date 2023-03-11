import 'dart:ui';

import 'package:flutter/widgets.dart';

class CustomRectTween extends RectTween {
  CustomRectTween({
    required Rect begin,
    required Rect end,
  }) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin?.left, end?.left, elasticCurveValue)!.toDouble(),
      lerpDouble(begin?.top, end?.top, elasticCurveValue)!.toDouble(),
      lerpDouble(begin?.right, end?.right, elasticCurveValue)!.toDouble(),
      lerpDouble(begin?.bottom, end?.bottom, elasticCurveValue)!.toDouble(),
    );
  }
}
