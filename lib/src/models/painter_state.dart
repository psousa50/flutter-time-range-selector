import '../../time_range_selector.dart';

enum ActiveTimeHandler {
  start,
  end,
}

typedef TimeRangePainterStateCallback = void Function(
    TimeRangePainterState painterState);

class TimeRangePainterState {
  final TimeRange timeRange;
  final ActiveTimeHandler? activeTimeHandler;

  TimeRangePainterState({
    required this.timeRange,
    this.activeTimeHandler,
  });

  TimeRangePainterState copyWith({
    TimeRange? timeRange,
    required ActiveTimeHandler? activeTimeHandler,
  }) {
    return TimeRangePainterState(
      timeRange: timeRange ?? this.timeRange,
      activeTimeHandler: activeTimeHandler,
    );
  }
}
