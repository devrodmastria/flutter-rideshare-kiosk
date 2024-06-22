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
      child: DigitalClock(
        decoration: BoxDecoration(
            color: Colors.grey.shade400,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        isLive: true,
        showSeconds: false,
        textScaleFactor: 3.3,
        datetime: DateTime.now(),
      ),
    );
  }
}
