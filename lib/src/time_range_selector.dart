import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'models/time_range_state.dart';
import 'models/time_range.dart';
import 'time_range_panel/display.dart';
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
    var timeRangeState = TimeRangeState(timeRange: timeRange);
    return ChangeNotifierProvider<TimeRangeState>.value(
        value: timeRangeState,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Consumer<TimeRangeState>(builder: (context, state, _) {
                return TimeRangeDisplay(state.timeRange);
              }),
              Expanded(
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 2,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 2,
                      child: TimeRangePanel(onTimeRangeChanged),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
