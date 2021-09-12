import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:time_range_selector/src/models/time_range_state.dart';

import '../models/painter_info.dart';
import 'canvas_state.dart';

final selectionColor = Colors.blue;
final handlerRadius = 15.0;

class TimeRangePainter extends CustomPainter {
  final TimeRangeState timeRangeState;
  final TimeRangeInfoCallback onPainterInfoChanged;

  TimeRangePainter(
    this.timeRangeState,
    this.onPainterInfoChanged,
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

    drawXLabel(canvas, canvasInfo, 0, labelOffset: 0.5);
    drawXLabel(canvas, canvasInfo, 6);
    drawXLabel(canvas, canvasInfo, 12);
    drawXLabel(canvas, canvasInfo, 18);
    drawXLabel(canvas, canvasInfo, 24, labelOffset: -0.5);

    var startTimeHandlerLocalPosition = canvasInfo.toScreen(timeRange.start!);
    var endTimeHandlerLocalPosition = canvasInfo.toScreen(timeRange.end!);
    onPainterInfoChanged(
      TimeRangePainterInfo(
        startTimeHandlerLocalPosition: startTimeHandlerLocalPosition,
        endTimeHandlerLocalPosition: endTimeHandlerLocalPosition,
        canvasSize: size,
        handlerRadius: handlerRadius,
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
      canvasInfo.segments(
        start,
        end,
      ),
      paint,
    );
  }

  void drawHandler(Canvas canvas, CanvasState canvasInfo, TimeOfDay t,
      {required bool active}) {
    var color = active ? selectionColor[500]! : selectionColor[900]!;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color;

    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    var center = canvasInfo.toScreen(t);
    canvas.drawCircle(center, handlerRadius, line);
    canvas.drawCircle(center, handlerRadius * .7, fill);
  }

  void drawTicks(Canvas canvas, CanvasState canvasInfo, int step, length) {
    for (var i = 0; i < 24 * 60; i += step) {
      var x = canvasInfo.timeToScreenX(fromMinutes(i));
      var y = canvasInfo.zeroY;
      canvas.drawLine(Offset(x, y), Offset(x, y + length), tickLine);
    }
  }

  void drawXLabel(Canvas canvas, CanvasState canvasInfo, int hour,
      {double labelOffset = 0}) {
    final textSpan = TextSpan(
      text: hour.toString(),
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: canvasInfo.width,
    );

    var x = canvasInfo.timeToScreenX(fromHour(hour));
    x = x - textPainter.width * (0.5 - labelOffset);
    var y = canvasInfo.zeroY + textPainter.height;
    final offset = Offset(x, y);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

final nightLine = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1
  ..color = Colors.red;

final dayLine = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1
  ..color = Colors.blue;

final horizonLine = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 2
  ..color = Colors.grey;

final selectedLine = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 8
  ..strokeCap = StrokeCap.round
  ..color = selectionColor;

final tickLine = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1
  ..color = Colors.grey;

final textStyle = TextStyle(
  color: Colors.grey,
  fontSize: 16,
);
