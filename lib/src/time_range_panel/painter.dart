import 'dart:ui';

import 'package:flutter/material.dart';

import '../customizations/time_range_selector_theme.dart';
import '../models/painter_info.dart';
import '../models/time_range_state.dart';
import 'canvas_state.dart';

class TimeRangePainter extends CustomPainter {
  final TimeRangeState timeRangeState;
  final TimeRangeInfoCallback onPainterInfoChanged;
  final TimeRangeSelectorThemeData theme;

  TimeRangePainter(
    this.timeRangeState,
    this.onPainterInfoChanged,
    this.theme,
  );

  TimeOfDay fromHour(int hour) {
    return TimeOfDay(hour: hour, minute: 0);
  }

  TimeOfDay fromMinutes(int minutes) {
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var canvasState = CanvasState(size);

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
      Offset(0, canvasState.zeroY),
      Offset(size.width, canvasState.zeroY),
      horizonLine,
    );

    drawLineSegment(canvas, canvasState, fromHour(0), fromHour(6), nightLine);
    drawLineSegment(canvas, canvasState, fromHour(6), fromHour(18), dayLine);
    drawLineSegment(canvas, canvasState, fromHour(18), fromHour(24), nightLine);

    var timeRange = timeRangeState.timeRange;
    var start = timeRange.start;
    var end = timeRange.end;
    var activeTimeHandler = timeRangeState.activeTimeHandler;
    drawLineSegment(canvas, canvasState, start!, end!, selectedLine);

    drawHandler(canvas, canvasState, timeRange.start!,
        active: activeTimeHandler == ActiveTimeHandler.start);
    drawHandler(canvas, canvasState, timeRange.end!,
        active: activeTimeHandler == ActiveTimeHandler.end);

    drawTicks(canvas, canvasState, 1 * 60, 5);
    drawTicks(canvas, canvasState, 3 * 60, 10);
    drawTicks(canvas, canvasState, 6 * 60, 20);

    drawXLabel(canvas, canvasState, 0);
    drawXLabel(canvas, canvasState, 3, small: true);
    drawXLabel(canvas, canvasState, 6);
    drawXLabel(canvas, canvasState, 9, small: true);
    drawXLabel(canvas, canvasState, 12);
    drawXLabel(canvas, canvasState, 15, small: true);
    drawXLabel(canvas, canvasState, 18);
    drawXLabel(canvas, canvasState, 21, small: true);
    drawXLabel(canvas, canvasState, 24);

    var startTimeHandlerLocalPosition =
        canvasState.timeOfDayToScreen(timeRange.start!);
    var endTimeHandlerLocalPosition =
        canvasState.timeOfDayToScreen(timeRange.end!);
    onPainterInfoChanged(
      TimeRangePainterInfo(
        startTimeHandlerLocalPosition: startTimeHandlerLocalPosition,
        endTimeHandlerLocalPosition: endTimeHandlerLocalPosition,
        canvasSize: size,
        handlerRadius: theme.handlerRadius!,
      ),
    );
  }

  void drawLineSegment(
    Canvas canvas,
    CanvasState canvasState,
    TimeOfDay start,
    TimeOfDay end,
    Paint paint,
  ) {
    canvas.drawPoints(
      PointMode.polygon,
      canvasState.timeLineSegment(
        start,
        end,
      ),
      paint,
    );
  }

  void drawHandler(Canvas canvas, CanvasState canvasState, TimeOfDay t,
      {required bool active}) {
    var color = active ? theme.activeHandlerColor : theme.handlerColor;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color!;

    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    var center = canvasState.timeOfDayToScreen(t);
    canvas.drawCircle(center, theme.handlerRadius!, line);
    canvas.drawCircle(center, theme.handlerRadius! * .7, fill);
  }

  void drawTicks(Canvas canvas, CanvasState canvasState, int step, length) {
    final tickLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = theme.ticksColor!;

    for (var i = 0; i <= 24 * 60; i += step) {
      var x = canvasState.timeToScreen(fromMinutes(i));
      var y = canvasState.zeroY;
      canvas.drawLine(Offset(x, y), Offset(x, y + length), tickLine);
    }
  }

  void drawXLabel(
    Canvas canvas,
    CanvasState canvasState,
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
      maxWidth: canvasState.width,
    );

    var x = canvasState.timeToScreen(fromHour(hour));
    x = x - textPainter.width * 0.5;
    var y = canvasState.zeroY + textPainter.height;
    final offset = Offset(x, y);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
