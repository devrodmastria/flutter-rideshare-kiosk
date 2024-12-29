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
            children: [
              ClockTool(),
              SizedBox(height: 24.0),
              BatteryMonitor(),
              SizedBox(height: 24.0),
              SizedBox(height: 260.0, child: ClimateControl()),
              // SizedBox(height: 150.0, child: IncomingRequests()),
            ],
          ),
        ));
  }
}
