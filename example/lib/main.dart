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

    var theme = TimeRangeSelectorThemeData(
      primaryColor: Colors.deepPurple,
      onPrimaryColor: Colors.yellowAccent,
      selectedColor: Colors.deepOrange,
      activeHandlerColor: Colors.amberAccent,
      activeDigitalColor: Colors.orange,
      handlerColor: Colors.amber,
      ticksColor: Colors.green,
      dayColor: Colors.blue[100],
      dayLineColor: Colors.blue[900],
      nightColor: Colors.blue[900],
      nightLineColor: Colors.blue[100],
      horizonColor: Colors.red,
      labelTextStyle: TextStyle(color: Colors.yellow),
      smallLabelTextStyle: TextStyle(color: Colors.red),
      timeTextDisplayStyle: TextStyle(
        fontSize: 14,
      ),
      handlerRadius: 20,
      margin: EdgeInsets.fromLTRB(50, 10, 50, 0),
    );

    const visibleTimeRange = TimeRange(
      start: TimeOfDay(hour: 5, minute: 0),
      end: TimeOfDay(hour: 18, minute: 0),
    );

    void showPicker(BuildContext context) async {
      var tr = await showTimeRangeSelector(
        context: context,
        timeRange: timeRange,
        onTimeRangeChanged: onTimeRangeChanged,
        theme: theme,
        visibleTimeRange: visibleTimeRange,
      );
      if (tr != null) {
        print("SELECTED: $tr");
      } else {
        print("CANCELED");
      }
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
              // theme: theme,
              minutesStep: 30,
            ),
          ),
        ],
      ),
    );
  }
}
