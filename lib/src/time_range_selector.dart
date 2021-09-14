import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_range_selector/generated/l10n.dart';

import 'models/time_range_state.dart';
import 'models/time_range.dart';
import 'time_range_panel/display.dart';
import 'time_range_panel/panel.dart';

typedef TimeRangeSelectorCallback = void Function(TimeRange timeRange);

class TimeRangeSelectorLocalizations {
  static var delegate = S.delegate;
}

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
        child: Column(
          children: [
            Consumer<TimeRangeState>(builder: (context, state, _) {
              return TimeRangeDisplay(state.timeRange);
            }),
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 3 / 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.blue[100],
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
                  aspectRatio: 3 / 2,
                  child: TimeRangePanel(onTimeRangeChanged),
                ),
              ],
            ),
          ],
        ));
  }
}
