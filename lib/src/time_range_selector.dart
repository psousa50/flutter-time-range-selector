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

const defaultVisibleTimeRange = TimeRange(
  start: TimeOfDay(hour: 0, minute: 0),
  end: TimeOfDay(hour: 24, minute: 0),
);

class TimeRangeSelector extends StatelessWidget {
  final TimeRange timeRange;
  final TimeRangeSelectorCallback onTimeRangeChanged;
  late final TimeRange visibleTimeRange;
  late final TimeRangeSelectorThemeData theme;
  late final int minutesStep;

  TimeRangeSelector({
    required this.timeRange,
    required this.onTimeRangeChanged,
    visibleTimeRange = defaultVisibleTimeRange,
    minutesStep,
    theme,
  }) {
    this.visibleTimeRange = visibleTimeRange ?? defaultVisibleTimeRange;
    this.theme = theme ?? TimeRangeSelectorThemeData();
    this.minutesStep = minutesStep ?? 10;
  }

  @override
  Widget build(BuildContext context) {
    var finalTimeRangeSelectorTheme = theme.mergeDefaults(
        TimeRangeSelectorTheme.of(context), Theme.of(context));
    var timeRangeState = TimeRangeState(timeRange: timeRange);

    return TimeRangeSelectorTheme(
      data: finalTimeRangeSelectorTheme,
      child: ChangeNotifierProvider<TimeRangeState>.value(
          value: timeRangeState,
          child: TimeRangePanel(
            onTimeRangeChanged: onTimeRangeChanged,
            minutesStep: minutesStep,
            visibleTimeRange: visibleTimeRange,
          )),
    );
  }
}

class TimeRangePanel extends StatelessWidget {
  final TimeRangeSelectorCallback onTimeRangeChanged;
  final int minutesStep;
  final TimeRange visibleTimeRange;

  const TimeRangePanel({
    Key? key,
    required this.onTimeRangeChanged,
    required this.minutesStep,
    required this.visibleTimeRange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = TimeRangeSelectorTheme.of(context);
    return Column(
      children: [
        Consumer<TimeRangeState>(builder: (context, state, _) {
          return TimeRangeDigital(state);
        }),
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 3 / 2,
              child: CanvasBackground(theme: theme),
            ),
            AspectRatio(
              aspectRatio: 3 / 2,
              child: TimeRangePanelCanvas(
                onTimeRangeChanged: onTimeRangeChanged,
                minutesStep: minutesStep,
                visibleTimeRange: visibleTimeRange,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CanvasBackground extends StatelessWidget {
  const CanvasBackground({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final TimeRangeSelectorThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: theme.dayColor,
          ),
        ),
        Expanded(
          child: Container(
            color: theme.nightColor,
          ),
        ),
      ],
    );
  }
}
