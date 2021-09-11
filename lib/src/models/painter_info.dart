import 'package:flutter/painting.dart';

typedef TimeRangeInfoCallback = void Function(TimeRangePainterInfo painterInfo);

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
