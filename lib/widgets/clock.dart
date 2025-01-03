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
  var clockColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          AnalogClock(
            width: 250.0,
            height: 250.0,
            isLive: true,
            hourHandColor: clockColor,
            minuteHandColor: clockColor,
            showSecondHand: false,
            numberColor: clockColor,
            showNumbers: true,
            showAllNumbers: true,
            textScaleFactor: 2.0,
            showTicks: true,
            tickColor: clockColor,
            showDigitalClock: false,
            digitalClockColor: clockColor,
            datetime: DateTime.now(),
          ),
          // DigitalClock(
          //   decoration: BoxDecoration(
          //       color: Colors.grey.shade400,
          //       shape: BoxShape.rectangle,
          //       borderRadius: const BorderRadius.all(Radius.circular(15))),
          //   isLive: true,
          //   showSeconds: false,
          //   textScaleFactor: 3.3,
          //   datetime: DateTime.now(),
          // ),
        ],
      ),
    );
  }
}
