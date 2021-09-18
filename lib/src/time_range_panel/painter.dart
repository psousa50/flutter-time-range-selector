import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:time_range_selector/time_range_selector.dart';

import '../customizations/time_range_selector_theme.dart';
import '../models/painter_info.dart';
import '../models/time_range_state.dart';
import 'time_range_canvas.dart';

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
