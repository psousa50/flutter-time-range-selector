import 'package:flutter/material.dart';
import 'package:time_range_selector/time_range_selector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var timeRange = TimeRange(
      start: TimeOfDay(hour: 7, minute: 0),
      end: TimeOfDay(hour: 15, minute: 0),
    );
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: TimeRangeSelector(
            timeRange: timeRange,
            onTimeRangeChanged: (_) {},
          ),
        ),
      ),
    );
  }
}
