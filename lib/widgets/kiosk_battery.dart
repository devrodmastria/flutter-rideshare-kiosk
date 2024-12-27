import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BatteryMonitor extends StatefulWidget {
  const BatteryMonitor({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BatteryMonitor();
  }
}

class _BatteryMonitor extends State<BatteryMonitor> {
  var _kioskBattery = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('ride').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final airStatusList = snapshot.data!.docs;
        _kioskBattery = airStatusList[0].data()['battery'];

        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Kiosk ${_kioskBattery.toString()}%',
                  style: const TextStyle(fontSize: 24, color: Colors.white)),
              const Icon(
                size: 25.0,
                Icons.battery_charging_full,
                color: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}
