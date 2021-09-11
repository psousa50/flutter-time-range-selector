import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (this.hour < other.hour) return -1;
    if (this.hour > other.hour) return 1;
    if (this.minute < other.minute) return -1;
    if (this.minute > other.minute) return 1;
    return 0;
  }

  bool isAfter(TimeOfDay other) {
    return compareTo(other) > 0;
  }

  bool isBefore(TimeOfDay other) {
    return compareTo(other) < 0;
  }

  int get minutes => hour * 60 + minute;
}
