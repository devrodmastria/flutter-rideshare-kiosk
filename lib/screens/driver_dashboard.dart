import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/widgets/clock.dart';
import 'package:kiosk/widgets/incoming_requests.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DriverDashboardState();
  }
}

class _DriverDashboardState extends State<DriverDashboard> {
  void _sendResponse() async {
    final userInfo = FirebaseAuth.instance.currentUser!;

    final rideMetaInfo = await FirebaseFirestore.instance
        .collection('ride')
        .doc('climate_status')
        .get();

    final climateStatus = rideMetaInfo.data()!['air'];

    FirebaseFirestore.instance.collection('ride').doc('climate_status').update({
      //firestore will create auto id for this map
      'air': !climateStatus,
      // 'text': (climateStatus.toString().contains('OFF') ? "airON" : "airOFF"),
      // 'createdAt': Timestamp.now(),
      // 'userId': userInfo.uid,
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      WakelockPlus.enable();
    });

    return Scaffold(
        backgroundColor: Colors.yellow.shade200,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClockTool(),
              SizedBox(
                height: 300,
                child: IncomingRequests(),
              )
            ],
          ),
        ));
  }
}
