import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/extensions.dart';

class CanvasInfo {
  final Size size;
  late List<Offset> points;
  final margin = 20.0;
  final minX = 0.0;
  final maxX = 24 * 60.0;
  late double minSX;
  late double maxSX;

  CanvasInfo(this.size) {
    minSX = 0 + margin;
    maxSX = size.width - margin;
    points = buildPoints();
  }

  double get zeroY => height / 2;

  List<Offset> buildPoints() {
    var points = Iterable<int>.generate((maxSX - minSX).toInt()).map(
      (p) {
        var xs = (p + minSX).toDouble();
        var x = toX(xs);
        var y = sin(x);
        var ys = toScreenY(y);
        return Offset(xs, ys);
      },
    ).toList();
    print(points.length);
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
    return transform(screenX, minSX, maxSX, -pi / 2, 3 * pi / 2);
  }

  double toScreenY(double y) {
    return transform(y, -1, 1, height, 0);
  }

  double timeToScreenX(TimeOfDay t) {
    return transform(t.minutes.toDouble(), minX, maxX, minSX, maxSX);
  }

  TimeOfDay screenXToTime(double x) {
    var minutes = transform(x, minSX, maxSX, minX, maxX).round();
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }

  Offset toScreen(TimeOfDay t) {
    return points[timeToScreenX(t).toInt() - margin.toInt()];
  }

  List<Offset> segments(TimeOfDay start, TimeOfDay end) {
    var x1 = timeToScreenX(start).toInt() - margin.toInt();
    var x2 = timeToScreenX(end).toInt() - margin.toInt();

    return points.sublist(x1, x2);
  }
}
