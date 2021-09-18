import 'package:flutter/painting.dart';

typedef TimeRangePainterInfoCallback = void Function(
    TimeRangePainterInfo painterInfo);

class TimeRangePainterInfo {
  final Offset startTimeHandlerLocalPosition;
  final Offset endTimeHandlerLocalPosition;
  final double handlerRadius;
  final Rect timeRect;
  final Rect screenRect;

  TimeRangePainterInfo(
      {required this.startTimeHandlerLocalPosition,
      required this.endTimeHandlerLocalPosition,
      required this.handlerRadius,
      required this.timeRect,
      required this.screenRect});
}
