import 'package:flutter/material.dart';
import 'package:kiosk/widgets/climate_control.dart';
import 'package:kiosk/widgets/clock.dart';
import 'package:kiosk/widgets/incoming_requests.dart';
import 'package:kiosk/widgets/kiosk_battery.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DriverDashboardState();
  }
}

class _DriverDashboardState extends State<DriverDashboard> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      WakelockPlus.enable();
    });

    return Scaffold(
        backgroundColor: Colors.blueGrey.shade800,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              ClockTool(),
              SizedBox(height: 8.0),
              BatteryMonitor(),
              SizedBox(height: 50),
              SizedBox(height: 300.0, child: ClimateControl()),
              SizedBox(height: 200.0, child: IncomingRequests()),
            ],
          ),
        ));
  }
}
