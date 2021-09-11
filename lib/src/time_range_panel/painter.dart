import 'dart:ui';

import 'package:flutter/material.dart';

import '../../time_range_selector.dart';
import '../models/painter_info.dart';
import '../models/painter_state.dart';
import 'panel.dart';

typedef TimeRangePainterCallback = void Function(
    TimeRangePainterInfo painterInfo);

class TimeRangePainter extends CustomPainter {
  final TimeRange timeRange;
  final ActiveTimeHandler? activeTimeHandler;
  final TimeRangePainterCallback onPainterInfoChanged;

  TimeRangePainter(
    this.timeRange,
    this.activeTimeHandler,
    this.onPainterInfoChanged,
  );

  TimeOfDay hour(int hour) {
    return TimeOfDay(hour: hour, minute: 0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var canvasInfo = CanvasInfo(size);

    drawLineSegment(canvas, canvasInfo, hour(0), hour(6), nightLine);

    drawLineSegment(canvas, canvasInfo, hour(6), hour(18), dayLine);

    drawLineSegment(canvas, canvasInfo, hour(18), hour(24), nightLine);

    var start = timeRange.start;
    var end = timeRange.end;
    drawLineSegment(canvas, canvasInfo, start!, end!, selectedLine);

    drawHandler(canvas, canvasInfo, timeRange.start!,
        active: activeTimeHandler == ActiveTimeHandler.start);
    drawHandler(canvas, canvasInfo, timeRange.end!,
        active: activeTimeHandler == ActiveTimeHandler.end);

    var startTimeHandlerLocalPosition = canvasInfo.toScreen(timeRange.start!);
    var endTimeHandlerLocalPosition = canvasInfo.toScreen(timeRange.end!);
    onPainterInfoChanged(
      TimeRangePainterInfo(
        startTimeHandlerLocalPosition: startTimeHandlerLocalPosition,
        endTimeHandlerLocalPosition: endTimeHandlerLocalPosition,
        canvasSize: size,
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
    var color = active ? Colors.blue[100]! : Colors.blue;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color;

    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    var center = canvasInfo.toScreen(t);
    canvas.drawCircle(center, 15, line);
    canvas.drawCircle(center, 10, fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
