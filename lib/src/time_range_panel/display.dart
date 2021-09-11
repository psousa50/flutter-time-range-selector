import 'package:flutter/material.dart';
import 'package:time_range_selector/src/models/painter_state.dart';

class TimeRangeDisplay extends StatelessWidget {
  final TimeRangePainterState painterState;

  const TimeRangeDisplay(this.painterState);

  String _addLeadingZeroIfNeeded(int value) {
    return (value < 10) ? "0$value" : "$value";
  }

  String timeString(TimeOfDay? t) {
    return t == null
        ? ""
        : "${_addLeadingZeroIfNeeded(t.hour)}:${_addLeadingZeroIfNeeded(t.minute)}";
  }

  Widget buildTimeDisplay(TimeOfDay? t) {
    return Expanded(child: Center(child: Text(timeString(t))));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildTimeDisplay(painterState.timeRange.start),
        buildTimeDisplay(painterState.timeRange.end),
      ],
    );
  }
}
