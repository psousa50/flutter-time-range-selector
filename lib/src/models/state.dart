import 'package:flutter/material.dart';

import '../../time_range_selector.dart';

enum ActiveTimeHandler {
  start,
  end,
}

class TimeRangeState with ChangeNotifier {
  TimeRange timeRange;
  ActiveTimeHandler? activeTimeHandler;

  TimeRangeState({
    required this.timeRange,
    this.activeTimeHandler,
  });

  void updateWith({
    TimeRange? timeRange,
    required ActiveTimeHandler? activeTimeHandler,
  }) {
    this.timeRange = timeRange ?? this.timeRange;
    this.activeTimeHandler = activeTimeHandler;

    notifyListeners();
  }
}
