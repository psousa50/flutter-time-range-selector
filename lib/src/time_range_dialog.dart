import 'package:flutter/material.dart';

import '../time_range_selector.dart';

Future<TimeRange?> showTimeRangeSelector({
  required BuildContext context,
  required TimeRange timeRange,
  required TimeRangeSelectorCallback onTimeRangeChanged,
  TransitionBuilder? builder,
  RouteSettings? routeSettings,
}) async {
  final Widget dialog = Dialog(
    elevation: 12,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TimeRangeSelector(
          timeRange: timeRange,
          onTimeRangeChanged: onTimeRangeChanged,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ACCEPT'),
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
