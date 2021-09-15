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
    var canvasInfo = CanvasState(size);

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
      Offset(0, canvasInfo.zeroY),
      Offset(size.width, canvasInfo.zeroY),
      horizonLine,
    );

    drawLineSegment(canvas, canvasInfo, fromHour(0), fromHour(6), nightLine);
    drawLineSegment(canvas, canvasInfo, fromHour(6), fromHour(18), dayLine);
    drawLineSegment(canvas, canvasInfo, fromHour(18), fromHour(24), nightLine);

    var timeRange = timeRangeState.timeRange;
    var start = timeRange.start;
    var end = timeRange.end;
    var activeTimeHandler = timeRangeState.activeTimeHandler;
    drawLineSegment(canvas, canvasInfo, start!, end!, selectedLine);

    drawHandler(canvas, canvasInfo, timeRange.start!,
        active: activeTimeHandler == ActiveTimeHandler.start);
    drawHandler(canvas, canvasInfo, timeRange.end!,
        active: activeTimeHandler == ActiveTimeHandler.end);

    drawTicks(canvas, canvasInfo, 1 * 60, 5);
    drawTicks(canvas, canvasInfo, 3 * 60, 10);
    drawTicks(canvas, canvasInfo, 6 * 60, 20);

    drawXLabel(canvas, canvasInfo, 0);
    drawXLabel(canvas, canvasInfo, 3, small: true);
    drawXLabel(canvas, canvasInfo, 6);
    drawXLabel(canvas, canvasInfo, 9, small: true);
    drawXLabel(canvas, canvasInfo, 12);
    drawXLabel(canvas, canvasInfo, 15, small: true);
    drawXLabel(canvas, canvasInfo, 18);
    drawXLabel(canvas, canvasInfo, 21, small: true);
    drawXLabel(canvas, canvasInfo, 24);

    var startTimeHandlerLocalPosition =
        canvasInfo.timeOfDayToScreen(timeRange.start!);
    var endTimeHandlerLocalPosition =
        canvasInfo.timeOfDayToScreen(timeRange.end!);
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
    CanvasState canvasInfo,
    TimeOfDay start,
    TimeOfDay end,
    Paint paint,
  ) {
    canvas.drawPoints(
      PointMode.polygon,
      canvasInfo.timeLineSegment(
        start,
        end,
      ),
      paint,
    );
  }

  void drawHandler(Canvas canvas, CanvasState canvasInfo, TimeOfDay t,
      {required bool active}) {
    var color = active ? theme.activeHandlerColor : theme.handlerColor;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color!;

    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    var center = canvasInfo.timeOfDayToScreen(t);
    canvas.drawCircle(center, theme.handlerRadius!, line);
    canvas.drawCircle(center, theme.handlerRadius! * .7, fill);
  }

  void drawTicks(Canvas canvas, CanvasState canvasInfo, int step, length) {
    final tickLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = theme.ticksColor!;

    for (var i = 0; i <= 24 * 60; i += step) {
      var x = canvasInfo.timeToScreen(fromMinutes(i));
      var y = canvasInfo.zeroY;
      canvas.drawLine(Offset(x, y), Offset(x, y + length), tickLine);
    }
  }

  void drawXLabel(
    Canvas canvas,
    CanvasState canvasInfo,
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
      maxWidth: canvasInfo.width,
    );

    var x = canvasInfo.timeToScreen(fromHour(hour));
    x = x - textPainter.width * 0.5;
    var y = canvasInfo.zeroY + textPainter.height;
    final offset = Offset(x, y);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
