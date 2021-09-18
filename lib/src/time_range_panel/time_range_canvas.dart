import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:time_range_selector/src/models/painter_info.dart';
import 'package:time_range_selector/src/models/time_range_state.dart';

import '../../time_range_selector.dart';
import '../models/extensions.dart';

final sineRect0 = Rect.fromLTRB(-pi / 2, 1, 3 * pi / 2, -1);
final timeRect0 = Rect.fromLTRB(0, 1, 24 * 60, -1);

class TimeRangeCanvas {
  final TimeRangeState timeRangeState;
  final TimeRangePainterInfoCallback onPainterInfoChanged;
  final TimeRangeSelectorThemeData theme;
  final Canvas canvas;
  final Size size;
  final TimeRange visibleTimeRange;
  late final Rect timeRect;
  late final Rect screenRect;
  late final List<Offset> points;

  TimeRangeCanvas(
    this.timeRangeState,
    this.onPainterInfoChanged,
    this.theme,
    this.canvas,
    this.size,
    this.visibleTimeRange,
  ) {
    var margin = theme.margin!;
    screenRect = Rect.fromLTRB(
      margin.left,
      margin.top,
      size.width - margin.right,
      size.height - margin.bottom,
    );
    var tx1 = visibleTimeRange.start!.minutes.toDouble();
    var tx2 = visibleTimeRange.end!.minutes.toDouble();
    timeRect = Rect.fromLTRB(tx1, 0, tx2, 0);
    points = buildPoints();
  }

  double get width => size.width;
  double get height => size.height;
  double get zeroY => height / 2;

  double timeToScreen(TimeOfDay t) {
    return transformX(t.minutes.toDouble(), timeRect, screenRect);
  }

  int toPointsIndex(TimeOfDay t) {
    return timeToScreen(t).toInt() - screenRect.left.toInt();
  }

  Offset timeOfDayToScreen(TimeOfDay t) {
    return points[toPointsIndex(t)];
  }

  List<Offset> timeLineSegment(TimeOfDay start, TimeOfDay end) {
    var x1 = min(points.length - 1, max(0, toPointsIndex(start)));
    var x2 = min(points.length - 1, max(0, toPointsIndex(end)));

    return points.sublist(x1, x2);
  }

  List<Offset> buildPoints() {
    var sineRect = Rect.fromLTRB(
      transformX(timeRect.left, timeRect0, sineRect0),
      sineRect0.top,
      transformX(timeRect.right, timeRect0, sineRect0),
      sineRect0.bottom,
    );
    var points = Iterable<int>.generate(screenRect.width.toInt()).map(
      (p) {
        var sx = (p + screenRect.left).toDouble();
        var x = transformX(sx, screenRect, sineRect);
        var y = sin(x);
        var sy = transformY(y, sineRect, screenRect);
        return Offset(sx, sy);
      },
    ).toList();
    return points;
  }

  void paint() {
    var selectedLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = theme.selectedColor!;

    final nightLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = theme.nightLineColor!;

    final dayLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = theme.dayLineColor!;

    final horizonLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = theme.horizonColor!;

    canvas.drawLine(
      Offset(0, zeroY),
      Offset(size.width, zeroY),
      horizonLine,
    );

    drawLineSegment(fromHour(0), fromHour(6), nightLine);
    drawLineSegment(fromHour(6), fromHour(18), dayLine);
    drawLineSegment(fromHour(18), fromHour(24), nightLine);

    var timeRange = timeRangeState.timeRange;
    var start = timeRange.start;
    var end = timeRange.end;
    var activeTimeHandler = timeRangeState.activeTimeHandler;
    drawLineSegment(start!, end!, selectedLine);

    drawHandler(timeRange.start!,
        active: activeTimeHandler == ActiveTimeHandler.start);
    drawHandler(timeRange.end!,
        active: activeTimeHandler == ActiveTimeHandler.end);

    drawTicks(1 * 60, 5);
    drawTicks(3 * 60, 10);
    drawTicks(6 * 60, 20);

    drawXLabel(0);
    drawXLabel(3, small: true);
    drawXLabel(6);
    drawXLabel(9, small: true);
    drawXLabel(12);
    drawXLabel(15, small: true);
    drawXLabel(18);
    drawXLabel(21, small: true);
    drawXLabel(24);

    var startTimeHandlerLocalPosition = timeOfDayToScreen(timeRange.start!);
    var endTimeHandlerLocalPosition = timeOfDayToScreen(timeRange.end!);
    onPainterInfoChanged(
      TimeRangePainterInfo(
        startTimeHandlerLocalPosition: startTimeHandlerLocalPosition,
        endTimeHandlerLocalPosition: endTimeHandlerLocalPosition,
        handlerRadius: theme.handlerRadius!,
        timeRect: timeRect,
        screenRect: screenRect,
      ),
    );
  }

  void drawLineSegment(
    TimeOfDay start,
    TimeOfDay end,
    Paint paint,
  ) {
    canvas.drawPoints(
      PointMode.polygon,
      timeLineSegment(
        start,
        end,
      ),
      paint,
    );
  }

  void drawHandler(TimeOfDay t, {required bool active}) {
    var color = active ? theme.activeHandlerColor : theme.handlerColor;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color!;

    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    var center = timeOfDayToScreen(t);
    canvas.drawCircle(center, theme.handlerRadius!, line);
    canvas.drawCircle(center, theme.handlerRadius! * .7, fill);
  }

  void drawTicks(int step, length) {
    final tickLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = theme.ticksColor!;

    for (var i = 0; i <= 24 * 60; i += step) {
      var x = timeToScreen(fromMinutes(i));
      var y = zeroY;
      canvas.drawLine(Offset(x, y), Offset(x, y + length), tickLine);
    }
  }

  void drawXLabel(
    int hour, {
    bool small = false,
  }) {
    final textSpan = TextSpan(
      text: hour.toString(),
      style: small ? theme.smallLabelTextStyle : theme.labelTextStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: width,
    );

    var x = timeToScreen(fromHour(hour));
    x = x - textPainter.width * 0.5;
    var y = zeroY + textPainter.height;
    final offset = Offset(x, y);
    textPainter.paint(canvas, offset);
  }
}

double transformX(
  double value,
  Rect sourceRect,
  Rect targetRect,
) {
  return (value - sourceRect.left) /
          (sourceRect.right - sourceRect.left) *
          (targetRect.right - targetRect.left) +
      targetRect.left;
}

double transformY(
  double value,
  Rect sourceRect,
  Rect targetRect,
) {
  return (value - sourceRect.top) /
          (sourceRect.bottom - sourceRect.top) *
          (targetRect.bottom - targetRect.top) +
      targetRect.top;
}

TimeOfDay fromHour(int hour) {
  return TimeOfDay(hour: hour, minute: 0);
}

TimeOfDay fromMinutes(int minutes) {
  return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
}
