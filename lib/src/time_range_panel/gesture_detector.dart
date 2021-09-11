import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef TimeGesturePanStartCallback = bool Function(Offset globalPosition);
typedef TimeGesturePanUpdateCallback = void Function(Offset globalPosition);
typedef TimeGesturePanEndCallback = void Function(Offset globalPosition);

class TimeGestureDetector extends StatelessWidget {
  final Function onPanStart;
  final Function onPanUpdate;
  final Function onPanEnd;
  final Widget child;

  const TimeGestureDetector({
    Key? key,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(gestures: <Type, GestureRecognizerFactory>{
      TimeGestureRecognizer:
          GestureRecognizerFactoryWithHandlers<TimeGestureRecognizer>(
        () => TimeGestureRecognizer(
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanEnd: onPanEnd,
        ),
        (TimeGestureRecognizer instance) {},
      ),
    }, child: child);
  }
}

class TimeGestureRecognizer extends OneSequenceGestureRecognizer {
  final Function onPanStart;
  final Function onPanUpdate;
  final Function onPanEnd;
  TimeGestureRecognizer({
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  void addPointer(PointerDownEvent event) {
    Offset position = event.position;
    if (onPanStart(position)) {
      startTrackingPointer(event.pointer);
      resolve(GestureDisposition.accepted);
    } else {
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    Offset position = event.position;
    if (event is PointerMoveEvent) {
      onPanUpdate(position);
    }
    if (event is PointerUpEvent) {
      onPanEnd(position);
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  String get debugDescription => "Time handler drag";

  @override
  void didStopTrackingLastPointer(int pointer) {}
}
