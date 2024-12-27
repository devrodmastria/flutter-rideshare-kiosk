import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiosk/widgets/carousel.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RiderHomeScreenState();
  }
}

void enableFullScreen() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      WakelockPlus.enable();
      enableFullScreen();
    });

    return Scaffold(
      appBar: AppBar(),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Carousel(),
          ),
        ],
      ),
    );
  }
}
