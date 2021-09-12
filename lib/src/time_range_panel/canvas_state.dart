import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/extensions.dart';

final sineRect = Rect.fromLTRB(-pi / 2, 1, 3 * pi / 2, -1);
final minutesRect = Rect.fromLTRB(0, 1, 24 * 60, -1);

class CanvasState {
  final xMargin = 20.0;
  final yMargin = 10.0;
  final Size size;
  late List<Offset> points;
  late Rect screenRect;
  late CoordsTransform screenToMinutes;
  late CoordsTransform screenToSine;

  CanvasState(this.size) {
    screenRect = Rect.fromLTRB(
      xMargin,
      yMargin,
      size.width - xMargin,
      size.height - yMargin,
    );
    screenToSine = CoordsTransform(screenRect, sineRect);
    screenToMinutes = CoordsTransform(screenRect, minutesRect);
    points = buildPoints();
  }

  double get zeroY => height / 2;

  List<Offset> buildPoints() {
    var points = Iterable<int>.generate(screenRect.width.toInt()).map(
      (p) {
        var sx = (p + screenRect.left).toDouble();
        var x = screenToSine.toX(sx);
        var y = sin(x);
        var sy = screenToSine.toInvertedY(y);
        return Offset(sx, sy);
      },
    ).toList();
    return points;
  }

  double get width => size.width;
  double get height => size.height;

  double timeToScreen(TimeOfDay t) {
    return screenToMinutes.invertX(t.minutes.toDouble());
  }

  TimeOfDay screenToTimeOfDay(double sx) {
    var minutes = screenToMinutes.toX(sx).round();
    minutes = max(0, minutes);
    minutes = min(24 * 60 - 1, minutes);
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }

  int toPointsIndex(TimeOfDay t) {
    return timeToScreen(t).toInt() - screenRect.left.toInt();
  }

  Offset timeOfDayToScreen(TimeOfDay t) {
    return points[toPointsIndex(t)];
  }

  List<Offset> timeLineSegment(TimeOfDay start, TimeOfDay end) {
    var x1 = toPointsIndex(start);
    var x2 = toPointsIndex(end);

    return points.sublist(x1, x2);
  }
}

class CoordsTransform {
  final Rect rect1;
  final Rect rect2;

  CoordsTransform(this.rect1, this.rect2);

  double _toX(
    double value,
    Rect sourceRect,
    Rect targetRect,
  ) {
    return (value - sourceRect.left) /
            (sourceRect.right - sourceRect.left) *
            (targetRect.right - targetRect.left) +
        targetRect.left;
  }

  double _toY(
    double value,
    Rect sourceRect,
    Rect targetRect,
  ) {
    return (value - sourceRect.top) /
            (sourceRect.bottom - sourceRect.top) *
            (targetRect.bottom - targetRect.top) +
        targetRect.top;
  }

  double toX(double value) {
    return _toX(value, rect1, rect2);
  }

  double invertX(double value) {
    return _toX(value, rect2, rect1);
  }

  double toY(double value) {
    return _toY(value, rect1, rect2);
  }

  double toInvertedY(double value) {
    return _toY(value, rect2, rect1);
  }
}
