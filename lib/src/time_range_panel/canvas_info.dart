import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class CanvasInfo {
  final Size size;
  late List<Offset> points;

  CanvasInfo(this.size) {
    points = buildPoints();
  }

  List<Offset> buildPoints() {
    var points = Iterable<int>.generate(width.toInt()).map(
      (p) {
        var xs = p.toDouble();
        var x = toX(xs);
        var y = sin(x);
        var ys = toScreenY(y);
        return Offset(xs, ys);
      },
    ).toList();
    return points;
  }

  double get width => size.width;
  double get height => size.height;

  double transform(
    double value,
    double s1,
    double e1,
    double s2,
    double e2,
  ) {
    return (value - s1) / (e1 - s1) * (e2 - s2) + s2;
  }

  double toX(double screenX) {
    return transform(screenX, 0, width, -pi / 2, 3 * pi / 2);
  }

  double toScreenY(double y) {
    return transform(y, -1, 1, height, 0);
  }

  double timeToScreenX(TimeOfDay t) {
    var minutes = t.hour * 60 + t.minute;
    return transform(minutes.toDouble(), 0, 24 * 60, 0, size.width);
  }

  TimeOfDay screenXToTime(double x) {
    var minutes = transform(x, 0, size.width, 0, 24 * 60);
    return TimeOfDay(hour: 0, minute: minutes.toInt());
  }

  Offset toScreen(TimeOfDay t) {
    return points[timeToScreenX(t).toInt()];
  }

  List<Offset> segments(TimeOfDay start, TimeOfDay end) {
    return points.sublist(
      timeToScreenX(start).toInt(),
      timeToScreenX(end).toInt(),
    );
  }
}
