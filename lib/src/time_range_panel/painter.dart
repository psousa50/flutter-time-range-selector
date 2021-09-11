import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:time_range_selector/src/models/time_range_state.dart';

import '../models/painter_info.dart';
import 'canvas_info.dart';

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

  @override
  void paint(Canvas canvas, Size size) {
    var canvasInfo = CanvasInfo(size);

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
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

    drawXLabel(canvas, canvasInfo, 0, labelOffset: 0.5);
    drawXLabel(canvas, canvasInfo, 6, labelOffset: 1);
    drawXLabel(canvas, canvasInfo, 12);
    drawXLabel(canvas, canvasInfo, 18, labelOffset: 1);
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
    CanvasInfo canvasInfo,
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

  void drawHandler(Canvas canvas, CanvasInfo canvasInfo, TimeOfDay t,
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

  void drawXLabel(Canvas canvas, CanvasInfo canvasInfo, int hour,
      {double labelOffset = 0}) {
    final textStyle = TextStyle(
      color: Colors.blue[900]!,
      fontSize: 16,
    );
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
    var y = canvasInfo.height / 2;
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
  ..color = Colors.white;

final dayLine = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1
  ..color = Colors.black;

final horizonLine = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1
  ..color = Colors.black;

final selectedLine = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 8
  ..strokeCap = StrokeCap.round
  ..color = selectionColor;
