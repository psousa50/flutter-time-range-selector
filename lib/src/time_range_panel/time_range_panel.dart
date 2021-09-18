import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_range_selector/src/time_range_panel/time_range_canvas.dart';

import '../../time_range_selector.dart';
import '../customizations/time_range_selector_theme.dart';
import '../models/painter_info.dart';
import '../models/time_range_state.dart';
import '../time_range_selector.dart';
import 'gesture_detector.dart';

class TimeRangePanelCanvas extends StatefulWidget {
  final TimeRangeSelectorCallback onTimeRangeChanged;
  final int minutesStep;
  final TimeRange visibleTimeRange;

  const TimeRangePanelCanvas({
    required this.onTimeRangeChanged,
    required this.minutesStep,
    required this.visibleTimeRange,
  });

  @override
  _TimeRangePanelCanvasState createState() => _TimeRangePanelCanvasState();
}

class _TimeRangePanelCanvasState extends State<TimeRangePanelCanvas> {
  TimeRangePainterInfo? _painterInfo;
  Offset _panOffset = Offset.zero;

  bool onPanStart(Offset globalPosition) {
    var painterInfo = _painterInfo;
    if (painterInfo == null) return false;

    var timeRangeState = Provider.of<TimeRangeState>(context, listen: false);
    var box = context.findRenderObject() as RenderBox;
    var localPosition = box.globalToLocal(globalPosition);

    var startOffset = localPosition - painterInfo.startTimeHandlerLocalPosition;
    var endOffset = (localPosition - painterInfo.endTimeHandlerLocalPosition);
    var distanceToStart = startOffset.distanceSquared;
    var distanceToEnd = endOffset.distanceSquared;

    var threshold = painterInfo.handlerRadius * painterInfo.handlerRadius;
    timeRangeState.updateWith(
        activeTimeHandler: distanceToEnd < threshold
            ? ActiveTimeHandler.end
            : distanceToStart < threshold
                ? ActiveTimeHandler.start
                : null);
    if (timeRangeState.activeTimeHandler != null) {
      _panOffset = timeRangeState.activeTimeHandler == ActiveTimeHandler.start
          ? startOffset
          : endOffset;
    }

    return timeRangeState.activeTimeHandler != null;
  }

  void onPanUpdate(Offset globalPosition) {
    var painterInfo = _painterInfo;
    if (painterInfo == null) return;

    var timeRangeState = Provider.of<TimeRangeState>(context, listen: false);
    var box = context.findRenderObject() as RenderBox;
    var localPosition = box.globalToLocal(globalPosition) - _panOffset;

    if (localPosition.dx >= painterInfo.screenRect.left &&
        localPosition.dx <= painterInfo.screenRect.right &&
        timeRangeState.activeTimeHandler != null) {
      var minutes = transformX(
              localPosition.dx, painterInfo.screenRect, painterInfo.timeRect)
          .round();

      minutes = max(0, minutes);
      minutes = min(24 * 60, minutes);
      minutes = minutes ~/ widget.minutesStep * widget.minutesStep;
      var time = TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);

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
    this._painterInfo = painterInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeRangeState>(builder: (_, state, __) {
      return TimeGestureDetector(
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        child: CustomPaint(
          painter: TimeRangePainter(state, onPainterInfoChanged,
              TimeRangeSelectorTheme.of(context), widget.visibleTimeRange),
        ),
      );
    });
  }
}

class TimeRangePainter extends CustomPainter {
  final TimeRangeState timeRangeState;
  final TimeRangePainterInfoCallback onPainterInfoChanged;
  final TimeRangeSelectorThemeData theme;
  final TimeRange visibleTimeRange;

  TimeRangePainter(
    this.timeRangeState,
    this.onPainterInfoChanged,
    this.theme,
    this.visibleTimeRange,
  );

  @override
  void paint(Canvas canvas, Size size) {
    var timeRangeCanvas = TimeRangeCanvas(
      timeRangeState,
      onPainterInfoChanged,
      theme,
      canvas,
      size,
      visibleTimeRange,
    );

    timeRangeCanvas.paint();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
