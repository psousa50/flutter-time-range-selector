import 'package:flutter/material.dart';
import 'package:time_range_selector/time_range_selector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales:
          TimeRangeSelectorLocalizations.delegate.supportedLocales,
      localizationsDelegates: [
        TimeRangeSelectorLocalizations.delegate,
      ],
      home: SafeArea(
        child: Scaffold(
          body: Home(),
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void onTimeRangeChanged(TimeRange timeRange) {
      print(timeRange);
    }

    var timeRange = TimeRange(
      start: TimeOfDay(hour: 7, minute: 0),
      end: TimeOfDay(hour: 15, minute: 0),
    );

    void showPicker(BuildContext context) {
      showTimeRangeSelector(
        context: context,
        timeRange: timeRange,
        onTimeRangeChanged: onTimeRangeChanged,
      );
    }

    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              showPicker(context);
            },
            child: Text("Dialog"),
          ),
          Expanded(
            child: TimeRangeSelector(
              timeRange: timeRange,
              onTimeRangeChanged: onTimeRangeChanged,
            ),
          ),
        ],
      ),
    );
  }
}
