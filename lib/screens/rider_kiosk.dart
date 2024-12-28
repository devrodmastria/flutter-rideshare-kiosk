import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiosk/widgets/carousel.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class RiderKiosk extends StatefulWidget {
  const RiderKiosk({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RiderKioskState();
  }
}

void enableFullScreen() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
}

class _RiderKioskState extends State<RiderKiosk> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      WakelockPlus.enable();
      enableFullScreen();
    });

    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Carousel(),
        ],
      ),
    );
  }
}
