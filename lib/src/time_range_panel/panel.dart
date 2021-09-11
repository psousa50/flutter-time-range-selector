import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../time_range_selector.dart';
import '../models/painter_info.dart';
import '../models/painter_state.dart';
import 'gesture_detector.dart';
import 'painter.dart';

final nightLine = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1
  ..color = Colors.white;

final dayLine = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1
  ..color = Colors.black;

final selectedLine = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 8
  ..strokeCap = StrokeCap.round
  ..color = Colors.lightBlue;

class CanvasInfo {
  final Size size;
  late List<Offset> points;

  CanvasInfo(this.size) {
    points = buildPoints();
  }

  List<Offset> buildPoints() {
    var points = Iterable<int>.generate(width.toInt()).map(
      (p) {
        var xs = p.toDouble();
        var x = toX(xs);
        var y = sin(x);
        var ys = toScreenY(y);
        return Offset(xs, ys);
      },
    ).toList();
    return points;
  }

  double get width => size.width;
  double get height => size.height;

  double transform(
    double value,
    double s1,
    double e1,
    double s2,
    double e2,
  ) {
    return (value - s1) / (e1 - s1) * (e2 - s2) + s2;
  }

  double toX(double screenX) {
    return transform(screenX, 0, width, -pi / 2, 3 * pi / 2);
  }

  double toScreenY(double y) {
    return transform(y, -1, 1, height, 0);
  }

  double timeToScreenX(TimeOfDay t) {
    var minutes = t.hour * 60 + t.minute;
    return transform(minutes.toDouble(), 0, 24 * 60, 0, size.width);
  }

  TimeOfDay screenXToTime(double x) {
    var minutes = transform(x, 0, size.width, 0, 24 * 60);
    return TimeOfDay(hour: 0, minute: minutes.toInt());
  }

  Offset toScreen(TimeOfDay t) {
    return points[timeToScreenX(t).toInt()];
  }

  List<Offset> segments(TimeOfDay start, TimeOfDay end) {
    return points.sublist(
      timeToScreenX(start).toInt(),
      timeToScreenX(end).toInt(),
    );
  }
}

class TimeRangePanel extends StatefulWidget {
  final TimeRange timeRange;

  const TimeRangePanel(this.timeRange);

  @override
  _TimeRangePanelState createState() => _TimeRangePanelState();
}

class _TimeRangePanelState extends State<TimeRangePanel> {
  late TimeRange timeRange;
  ActiveTimeHandler? activeTimeHandler;
  TimeRangePainterInfo? painterInfo;

  @override
  void initState() {
    timeRange = widget.timeRange;
    super.initState();
  }

  @override
  void didUpdateWidget(TimeRangePanel oldWidget) {
    timeRange = widget.timeRange;
    super.didUpdateWidget(oldWidget);
  }

  bool onPanStart(Offset globalPosition) {
    if (painterInfo == null) return false;

    var box = context.findRenderObject() as RenderBox;
    var localPosition = box.globalToLocal(globalPosition);

    var distanceToStart =
        (localPosition - painterInfo!.startTimeHandlerLocalPosition)
            .distanceSquared;
    var distanceToEnd =
        (localPosition - painterInfo!.endTimeHandlerLocalPosition)
            .distanceSquared;

    activeTimeHandler = distanceToEnd < 50
        ? ActiveTimeHandler.end
        : distanceToStart < 50
            ? ActiveTimeHandler.start
            : null;

    if (activeTimeHandler != null) {
      updateTimeHandler(localPosition);
    }

    return activeTimeHandler != null;
  }

  void onPanUpdate(Offset globalPosition) {
    if (painterInfo == null) return;

    var box = context.findRenderObject() as RenderBox;
    var localPosition = box.globalToLocal(globalPosition);

    if (localPosition.dx >= 0 &&
        localPosition.dx < painterInfo!.canvasSize.width &&
        activeTimeHandler != null) {
      updateTimeHandler(localPosition);
    }
  }

  void updateTimeHandler(Offset localPosition) {
    if (painterInfo == null) return;

    var canvasInfo = CanvasInfo(painterInfo!.canvasSize);
    var time = canvasInfo.screenXToTime(localPosition.dx);
    setState(() {
      timeRange = timeRange.copyWith(
        start: activeTimeHandler == ActiveTimeHandler.start ? time : null,
        end: activeTimeHandler == ActiveTimeHandler.end ? time : null,
      );
    });
  }

  void onPanEnd(Offset globalPosition) {
    setState(() {
      activeTimeHandler = null;
    });
  }

  void onPainterInfoChanged(TimeRangePainterInfo painterInfo) {
    this.painterInfo = painterInfo;
  }

  @override
  Widget build(BuildContext context) {
    return TimeGestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: CustomPaint(
        painter: TimeRangePainter(
          timeRange,
          activeTimeHandler,
          onPainterInfoChanged,
        ),
      ),
    );
  }
}
