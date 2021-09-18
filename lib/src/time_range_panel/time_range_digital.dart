import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../time_range_selector.dart';
import '../models/time_range_state.dart';

class TimeRangeDigital extends StatelessWidget {
  final TimeRangeState timeRangeState;

  const TimeRangeDigital(this.timeRangeState);

  String _addLeadingZeroIfNeeded(int value) {
    return (value < 10) ? "0$value" : "$value";
  }

  String timeString(TimeOfDay? t) {
    return t == null
        ? ""
        : "${_addLeadingZeroIfNeeded(t.hour)}:${_addLeadingZeroIfNeeded(t.minute)}";
  }

  Widget buildTimeDisplay(BuildContext context, TimeOfDay? t, String title,
      {bool selected = false}) {
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
                style: selected
                    ? theme.timeDisplayStyle!
                        .merge(TextStyle(color: theme.selectedColor))
                    : theme.timeDisplayStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var timeRange = timeRangeState.timeRange;
    return Container(
      color: TimeRangeSelectorTheme.of(context).primaryColor,
      child: Row(
        children: [
          buildTimeDisplay(
            context,
            timeRange.start,
            S.of(context).from,
            selected:
                timeRangeState.activeTimeHandler == ActiveTimeHandler.start,
          ),
          buildTimeDisplay(
            context,
            timeRange.end,
            S.of(context).to,
            selected: timeRangeState.activeTimeHandler == ActiveTimeHandler.end,
          ),
        ],
      ),
    );
  }
}
