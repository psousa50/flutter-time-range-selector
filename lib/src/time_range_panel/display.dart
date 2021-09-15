import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../time_range_selector.dart';
import '../models/time_range.dart';

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
    var theme = TimeRangeSelectorTheme.of(context);
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Text(
                title,
                style: theme.timeTextDisplayStyle,
              ),
              Text(
                timeString(t),
                style: theme.timeDisplayStyle,
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
      color: TimeRangeSelectorTheme.of(context).primaryColor,
      child: Row(
        children: [
          buildTimeDisplay(context, timeRange.start, S.of(context).from),
          buildTimeDisplay(context, timeRange.end, S.of(context).to),
        ],
      ),
    );
  }
}
