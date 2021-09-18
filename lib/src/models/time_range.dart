import 'package:flutter/material.dart';

import 'extensions.dart';

class TimeRange {
  final TimeOfDay? start;
  final TimeOfDay? end;

  const TimeRange({
    this.start,
    this.end,
  });

  bool get inverted => end != null && start != null && end!.isBefore(start!);

  TimeRange invert() => copyWith(start: end, end: start);

  TimeRange copyWith({
    TimeOfDay? start,
    TimeOfDay? end,
  }) {
    return TimeRange(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  String toString() {
    return "$start - $end";
  }
}
