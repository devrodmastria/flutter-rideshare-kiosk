import 'package:flutter/material.dart';
import 'package:kiosk/widgets/carousel.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ControlScreenState();
  }
}

class _ControlScreenState extends State<ControlScreen> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      WakelockPlus.enable();
    });

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // const Icon(Icons.arrow_upward, size: 50), // volume btn guide
          // const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Carousel(),
          ),
        ],
      ),
    );
  }
}
