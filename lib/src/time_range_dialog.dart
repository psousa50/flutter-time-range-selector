import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../time_range_selector.dart';

Future<TimeRange?> showTimeRangeSelector({
  required BuildContext context,
  required TimeRange timeRange,
  TimeRangeSelectorCallback? onTimeRangeChanged,
  TimeRange? visibleTimeRange,
  TimeRangeSelectorThemeData? theme,
  TransitionBuilder? builder,
  RouteSettings? routeSettings,
}) async {
  var localTimeRange = timeRange;
  final Widget dialog = Dialog(
    elevation: 12,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TimeRangeSelector(
            timeRange: timeRange,
            onTimeRangeChanged: (timeRange) {
              localTimeRange = timeRange;
              onTimeRangeChanged?.call(timeRange);
            },
            theme: theme,
            visibleTimeRange: visibleTimeRange),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(S.of(context).Cancel.toUpperCase()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(localTimeRange);
                },
                child: Text(S.of(context).Ok.toUpperCase()),
              ),
            ],
          ),
        )
      ],
    ),
  );

  return await showDialog<TimeRange>(
    context: context,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    routeSettings: routeSettings,
  );
}
