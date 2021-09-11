import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'models/state.dart';
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
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.black,
                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(0.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
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
