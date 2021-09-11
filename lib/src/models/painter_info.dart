import 'package:flutter/painting.dart';

class TimeRangePainterInfo {
  final Offset startTimeHandlerLocalPosition;
  final Offset endTimeHandlerLocalPosition;
  final Size canvasSize;
  final double handlerRadius;

  TimeRangePainterInfo({
    required this.startTimeHandlerLocalPosition,
    required this.endTimeHandlerLocalPosition,
    required this.canvasSize,
    required this.handlerRadius,
  });
}
