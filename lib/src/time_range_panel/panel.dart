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
  final TimeRangePainterStateCallback onPainterStateUpdated;

  const TimeRangePanel(
    this.timeRange,
    this.onPainterStateUpdated,
  );

  @override
  _TimeRangePanelState createState() => _TimeRangePanelState();
}

class _TimeRangePanelState extends State<TimeRangePanel> {
  late TimeRangePainterState painterState;
  TimeRangePainterInfo? painterInfo;
  Offset panOffset = Offset.zero;

  @override
  void initState() {
    painterState = TimeRangePainterState(timeRange: widget.timeRange);
    super.initState();
  }

  @override
  void didUpdateWidget(TimeRangePanel oldWidget) {
    painterState = painterState.copyWith(
      timeRange: widget.timeRange,
      activeTimeHandler: painterState.activeTimeHandler,
    );
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
    painterState = painterState.copyWith(
        activeTimeHandler: distanceToEnd < threshold
            ? ActiveTimeHandler.end
            : distanceToStart < threshold
                ? ActiveTimeHandler.start
                : null);
    if (painterState.activeTimeHandler != null) {
      setState(() {
        panOffset = painterState.activeTimeHandler == ActiveTimeHandler.start
            ? startOffset
            : endOffset;
        widget.onPainterStateUpdated(painterState);
      });
    }

    return painterState.activeTimeHandler != null;
  }

  void onPanUpdate(Offset globalPosition) {
    if (painterInfo == null) return;

    var box = context.findRenderObject() as RenderBox;
    var localPosition = box.globalToLocal(globalPosition) - panOffset;

    if (localPosition.dx >= 0 &&
        localPosition.dx < painterInfo!.canvasSize.width &&
        painterState.activeTimeHandler != null) {
      var canvasInfo = CanvasInfo(painterInfo!.canvasSize);
      var time = canvasInfo.screenXToTime(localPosition.dx);
      var newTimeRange = painterState.timeRange.copyWith(
        start: painterState.activeTimeHandler == ActiveTimeHandler.start
            ? time
            : null,
        end: painterState.activeTimeHandler == ActiveTimeHandler.end
            ? time
            : null,
      );
      var newPainterState = painterState.copyWith(
        timeRange: newTimeRange,
        activeTimeHandler: painterState.activeTimeHandler,
      );
      if (newPainterState.timeRange.inverted) {
        newPainterState = newPainterState.copyWith(
            timeRange: newPainterState.timeRange.invert(),
            activeTimeHandler:
                newPainterState.activeTimeHandler == ActiveTimeHandler.start
                    ? ActiveTimeHandler.end
                    : ActiveTimeHandler.start);
      }
      setState(() {
        painterState = newPainterState;
        widget.onPainterStateUpdated(painterState);
      });
    }
  }

  void onPanEnd(Offset globalPosition) {
    setState(() {
      painterState = painterState.copyWith(activeTimeHandler: null);
      widget.onPainterStateUpdated(painterState);
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
          painterState,
          onPainterInfoChanged,
        ),
      ),
    );
  }
}
