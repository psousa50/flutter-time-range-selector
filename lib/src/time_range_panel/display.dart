import 'package:flutter/material.dart';
import 'package:time_range_selector/src/models/time_range.dart';

class TimeRangeDisplay extends StatelessWidget {
  final TimeRange timeRange;

  const TimeRangeDisplay(this.timeRange);

  String _addLeadingZeroIfNeeded(int value) {
    return (value < 10) ? "0$value" : "$value";
  }

  String timeString(TimeOfDay? t) {
    return t == null
        ? ""
        : "${_addLeadingZeroIfNeeded(t.hour)}:${_addLeadingZeroIfNeeded(t.minute)}";
  }

  Widget buildTimeDisplay(TimeOfDay? t) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          child: Text(
            timeString(t),
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildTimeDisplay(timeRange.start),
        buildTimeDisplay(timeRange.end),
      ],
    );
  }
}
