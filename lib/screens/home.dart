import 'package:flutter/material.dart';
import 'package:kiosk/widgets/carousel.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      WakelockPlus.enable();
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
