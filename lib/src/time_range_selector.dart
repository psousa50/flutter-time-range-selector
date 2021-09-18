import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import 'customizations/time_range_selector_theme.dart';
import 'models/time_range.dart';
import 'models/time_range_state.dart';
import 'time_range_panel/time_range_digital.dart';
import 'time_range_panel/time_range_panel.dart';

typedef TimeRangeSelectorCallback = void Function(TimeRange timeRange);

class TimeRangeSelectorLocalizations {
  static var delegate = S.delegate;
}

class TimeRangeSelector extends StatelessWidget {
  final TimeRange timeRange;
  final TimeRangeSelectorCallback onTimeRangeChanged;
  final TimeRangeSelectorThemeData theme;
  final int minutesStep;

  const TimeRangeSelector({
    required this.timeRange,
    required this.onTimeRangeChanged,
    this.theme = const TimeRangeSelectorThemeData(),
    this.minutesStep = 10,
  });

  @override
  Widget build(BuildContext context) {
    var finalTimeRangeSelectorTheme = theme.mergeDefaults(
        TimeRangeSelectorTheme.of(context), Theme.of(context));
    var timeRangeState = TimeRangeState(timeRange: timeRange);

    return TimeRangeSelectorTheme(
      data: finalTimeRangeSelectorTheme,
      child: ChangeNotifierProvider<TimeRangeState>.value(
          value: timeRangeState,
          child: Column(
            children: [
              Consumer<TimeRangeState>(builder: (context, state, _) {
                return TimeRangeDigital(state);
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
                    child: TimeRangePanel(
                      onTimeRangeChanged: onTimeRangeChanged,
                      minutesStep: minutesStep,
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
