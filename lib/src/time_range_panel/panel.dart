import 'dart:ui';

import 'package:flutter/material.dart';

import '../../time_range_selector.dart';
import '../models/painter_info.dart';
import '../models/painter_state.dart';
import 'canvas_info.dart';
import 'gesture_detector.dart';
import 'painter.dart';

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
  Offset panOffset = Offset.zero;

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

    var startOffset =
        localPosition - painterInfo!.startTimeHandlerLocalPosition;
    var endOffset = (localPosition - painterInfo!.endTimeHandlerLocalPosition);
    var distanceToStart = startOffset.distanceSquared;
    var distanceToEnd = endOffset.distanceSquared;

    var threshold = painterInfo!.handlerRadius * painterInfo!.handlerRadius;
    activeTimeHandler = distanceToEnd < threshold
        ? ActiveTimeHandler.end
        : distanceToStart < threshold
            ? ActiveTimeHandler.start
            : null;
    if (activeTimeHandler != null) {
      setState(() {
        panOffset = activeTimeHandler == ActiveTimeHandler.start
            ? startOffset
            : endOffset;
      });
    }

    return activeTimeHandler != null;
  }

  void onPanUpdate(Offset globalPosition) {
    if (painterInfo == null) return;

    var box = context.findRenderObject() as RenderBox;
    var localPosition = box.globalToLocal(globalPosition) - panOffset;

    if (localPosition.dx >= 0 &&
        localPosition.dx < painterInfo!.canvasSize.width &&
        activeTimeHandler != null) {
      var canvasInfo = CanvasInfo(painterInfo!.canvasSize);
      var time = canvasInfo.screenXToTime(localPosition.dx);
      var newTimeRange = timeRange.copyWith(
        start: activeTimeHandler == ActiveTimeHandler.start ? time : null,
        end: activeTimeHandler == ActiveTimeHandler.end ? time : null,
      );
      if (newTimeRange.inverted) {
        newTimeRange = newTimeRange.invert();
        activeTimeHandler = activeTimeHandler == ActiveTimeHandler.start
            ? ActiveTimeHandler.end
            : ActiveTimeHandler.start;
      }
      setState(() {
        timeRange = newTimeRange;
      });
    }
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
