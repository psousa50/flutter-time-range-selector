import 'package:flutter/material.dart';
import 'package:time_range_selector/generated/l10n.dart';
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

  Widget buildTimeDisplay(BuildContext context, TimeOfDay? t, String title) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).selectedRowColor,
                ),
              ),
              Text(
                timeString(t),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).selectedRowColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          buildTimeDisplay(context, timeRange.start, S.of(context).from),
          buildTimeDisplay(context, timeRange.end, S.of(context).to),
        ],
      ),
    );
  }
}
