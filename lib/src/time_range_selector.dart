import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:time_range_selector/src/models/painter_state.dart';

import 'models/time_range.dart';
import 'time_range_panel/display.dart';
import 'time_range_panel/panel.dart';

typedef TimeRangeSelectorCallback = void Function(TimeRange timeRange);

class TimeRangeSelector extends StatefulWidget {
  final TimeRange timeRange;
  final TimeRangeSelectorCallback onTimeRangeChanged;

  const TimeRangeSelector({
    required this.timeRange,
    required this.onTimeRangeChanged,
  });

  @override
  _TimeRangeSelectorState createState() => _TimeRangeSelectorState();
}

class _TimeRangeSelectorState extends State<TimeRangeSelector> {
  late TimeRangePainterState painterState;

  @override
  void initState() {
    painterState = TimeRangePainterState(timeRange: widget.timeRange);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TimeRangeSelector oldWidget) {
    painterState = TimeRangePainterState(timeRange: widget.timeRange);
    super.didUpdateWidget(oldWidget);
  }

  void onTimeRangePainterStateChanged(TimeRangePainterState painterState) {
    setState(() {
      this.painterState = painterState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TimeRangeDisplay(painterState),
          Expanded(
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.black,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(0.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                  ),
                ),
                AspectRatio(
                  aspectRatio: 2,
                  child: TimeRangePanel(
                    painterState.timeRange,
                    onTimeRangePainterStateChanged,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
