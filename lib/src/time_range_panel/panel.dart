import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_range_selector/src/models/time_range_state.dart';

import '../models/painter_info.dart';
import '../time_range_selector.dart';
import 'canvas_state.dart';
import 'gesture_detector.dart';
import 'painter.dart';

class TimeRangePanel extends StatefulWidget {
  final TimeRangeSelectorCallback onTimeRangeChanged;

  const TimeRangePanel(this.onTimeRangeChanged);

  @override
  _TimeRangePanelState createState() => _TimeRangePanelState();
}

class _TimeRangePanelState extends State<TimeRangePanel> {
  TimeRangePainterInfo? painterInfo;
  Offset panOffset = Offset.zero;

  bool onPanStart(Offset globalPosition) {
    if (painterInfo == null) return false;

    var timeRangeState = Provider.of<TimeRangeState>(context, listen: false);
    var box = context.findRenderObject() as RenderBox;
    var localPosition = box.globalToLocal(globalPosition);

    var startOffset =
        localPosition - painterInfo!.startTimeHandlerLocalPosition;
    var endOffset = (localPosition - painterInfo!.endTimeHandlerLocalPosition);
    var distanceToStart = startOffset.distanceSquared;
    var distanceToEnd = endOffset.distanceSquared;

    var threshold = painterInfo!.handlerRadius * painterInfo!.handlerRadius;
    timeRangeState.updateWith(
        activeTimeHandler: distanceToEnd < threshold
            ? ActiveTimeHandler.end
            : distanceToStart < threshold
                ? ActiveTimeHandler.start
                : null);
    if (timeRangeState.activeTimeHandler != null) {
      panOffset = timeRangeState.activeTimeHandler == ActiveTimeHandler.start
          ? startOffset
          : endOffset;
    }

    return timeRangeState.activeTimeHandler != null;
  }

  void onPanUpdate(Offset globalPosition) {
    if (painterInfo == null) return;

    var timeRangeState = Provider.of<TimeRangeState>(context, listen: false);
    var box = context.findRenderObject() as RenderBox;
    var localPosition = box.globalToLocal(globalPosition) - panOffset;

    if (localPosition.dx >= 0 &&
        localPosition.dx < painterInfo!.canvasSize.width &&
        timeRangeState.activeTimeHandler != null) {
      var canvasInfo = CanvasState(painterInfo!.canvasSize);
      var time = canvasInfo.screenXToTime(localPosition.dx);
      var newTimeRange = timeRangeState.timeRange.copyWith(
        start: timeRangeState.activeTimeHandler == ActiveTimeHandler.start
            ? time
            : null,
        end: timeRangeState.activeTimeHandler == ActiveTimeHandler.end
            ? time
            : null,
      );

      if (newTimeRange.inverted) {
        timeRangeState.updateWith(
            timeRange: newTimeRange.invert(),
            activeTimeHandler:
                timeRangeState.activeTimeHandler == ActiveTimeHandler.start
                    ? ActiveTimeHandler.end
                    : ActiveTimeHandler.start);
      } else {
        timeRangeState.updateWith(
            timeRange: newTimeRange,
            activeTimeHandler: timeRangeState.activeTimeHandler);
      }
    }
  }

  void onPanEnd(Offset globalPosition) {
    var timeRangeState = Provider.of<TimeRangeState>(context, listen: false);
    timeRangeState.updateWith(activeTimeHandler: null);
    widget.onTimeRangeChanged(timeRangeState.timeRange);
  }

  void onPainterInfoChanged(TimeRangePainterInfo painterInfo) {
    this.painterInfo = painterInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeRangeState>(builder: (_, state, __) {
      return TimeGestureDetector(
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        child: CustomPaint(
          painter: TimeRangePainter(
            state,
            onPainterInfoChanged,
          ),
        ),
      );
    });
  }
}
