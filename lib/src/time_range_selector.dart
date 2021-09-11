import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'models/time_range.dart';
import 'time_range_panel/panel.dart';

typedef TimeRangeSelectorCallback = void Function(TimeRange timeRange);

class TimeRangeSelector extends StatelessWidget {
  final TimeRange timeRange;
  final TimeRangeSelectorCallback onTimeRangeChanged;

  const TimeRangeSelector({
    required this.timeRange,
    required this.onTimeRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: Column(
              children: [
                Expanded(child: Container(color: Colors.grey[50])),
                Expanded(child: Container(color: Colors.black)),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 2,
            child: TimeRangePanel(timeRange),
          )
        ],
      ),
    );
  }
}
