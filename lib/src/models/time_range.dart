import 'package:flutter/material.dart';

class TimeRange {
  final TimeOfDay? start;
  final TimeOfDay? end;

  TimeRange({
    this.start,
    this.end,
  });

  TimeRange copyWith({
    TimeOfDay? start,
    TimeOfDay? end,
  }) {
    return TimeRange(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }
}
