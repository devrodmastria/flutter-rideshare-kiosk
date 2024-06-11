import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';

class ClockTool extends StatefulWidget {
  const ClockTool({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ClockToolState();
  }
}

class _ClockToolState extends State<ClockTool> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnalogClock(
        decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.black),
            color: Colors.transparent,
            shape: BoxShape.circle),
        height: 250.0,
        width: 250.0,
        isLive: true,
        hourHandColor: Colors.black,
        minuteHandColor: Colors.black,
        showSecondHand: false,
        numberColor: Colors.black87,
        showNumbers: true,
        showAllNumbers: true,
        textScaleFactor: 1.4,
        showTicks: false,
        showDigitalClock: false,
        datetime: DateTime.now(),
      ),
    );
  }
}
