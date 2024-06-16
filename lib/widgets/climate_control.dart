import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/data/data.dart';

class ClimateControl extends StatefulWidget {
  const ClimateControl({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ClimateControlState();
  }
}

class _ClimateControlState extends State<ClimateControl> {
  final ButtonStyle airBtnStyleHeat = OutlinedButton.styleFrom(
    padding: const EdgeInsets.all(16),
    foregroundColor: Colors.white,
    backgroundColor: Colors.red.shade400,
    textStyle: const TextStyle(fontSize: 28),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );

  final ButtonStyle airBtnStyleCold = OutlinedButton.styleFrom(
    padding: const EdgeInsets.all(16),
    foregroundColor: Colors.white,
    backgroundColor: Colors.blue.shade900,
    textStyle: const TextStyle(fontSize: 28),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );

  final ButtonStyle airBtnStyleOff = OutlinedButton.styleFrom(
    padding: const EdgeInsets.all(16),
    foregroundColor: Colors.white,
    backgroundColor: Colors.grey.shade900,
    textStyle: const TextStyle(fontSize: 28),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );

  final ButtonStyle airSpeedBtnStyle = OutlinedButton.styleFrom(
    padding: const EdgeInsets.all(16),
    foregroundColor: Colors.black54,
    backgroundColor: Colors.white70,
    textStyle: const TextStyle(fontSize: 28),
    shape: RoundedRectangleBorder(
      side: BorderSide(width: 4.0, color: Colors.blue.shade800),
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );

  final ButtonStyle airSpeedBtnStyleOff = OutlinedButton.styleFrom(
    padding: const EdgeInsets.all(16),
    foregroundColor: Colors.black54,
    backgroundColor: Colors.white70,
    textStyle:
        const TextStyle(fontSize: 28, decoration: TextDecoration.lineThrough),
    shape: RoundedRectangleBorder(
      side: BorderSide(width: 4.0, color: Colors.blue.shade800),
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );

  var _airStatus = AirStatus.cold.toString();
  var _fanSpeed = 1;

  void _sendSpeedRequest() async {
    _fanSpeed = _fanSpeed == 1
        ? 2
        : _fanSpeed == 2
            ? 3
            : _fanSpeed == 3
                ? 4
                : _fanSpeed == 4
                    ? 1
                    : 1;

    FirebaseFirestore.instance.collection('ride').doc('climate_status').update({
      'speed': _fanSpeed,
      'fanCreatedAt': Timestamp.now().millisecondsSinceEpoch,
    });
  }

  void _sendTemperatureRequest() async {
    // final userInfo = FirebaseAuth.instance.currentUser!;

    _airStatus = _airStatus == AirStatus.cold.toString()
        ? AirStatus.heat.toString()
        : _airStatus == AirStatus.heat.toString()
            ? AirStatus.off.toString()
            : _airStatus == AirStatus.off.toString()
                ? AirStatus.cold.toString()
                : AirStatus.cold.toString();

    // final rideMetaInfo = await FirebaseFirestore.instance
    //     .collection('ride')
    //     .doc('climate_status')
    //     .get();

    // final climateStatus = rideMetaInfo.data()!['air'];

    FirebaseFirestore.instance.collection('ride').doc('climate_status').update({
      'air': _airStatus,
      'tempCreatedAt': Timestamp.now().millisecondsSinceEpoch,
    });
  }

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
        _airStatus = airStatusList[0].data()['air'];
        _fanSpeed = airStatusList[0].data()['speed'];

        return Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: 300.0,
              child: ElevatedButton.icon(
                onPressed: () {
                  _sendTemperatureRequest();
                },
                style: _airStatus == AirStatus.cold.toString()
                    ? airBtnStyleCold
                    : _airStatus == AirStatus.heat.toString()
                        ? airBtnStyleHeat
                        : airBtnStyleOff,
                label: Text(_airStatus == AirStatus.cold.toString()
                    ? 'A/C ON'
                    : _airStatus == AirStatus.heat.toString()
                        ? 'Heat ON'
                        : 'Air/Heat Off'),
                icon: const Icon(Icons.sunny_snowing),
              ),
            ),
            const SizedBox(width: 24),
            SizedBox(
              width: 300.0,
              child: ElevatedButton.icon(
                onPressed: () {
                  (_airStatus != AirStatus.off.toString())
                      ? _sendSpeedRequest()
                      : null;
                },
                style: (_airStatus != AirStatus.off.toString())
                    ? airSpeedBtnStyle
                    : airSpeedBtnStyleOff,
                label: Text(
                    'Fan speed: ${(_fanSpeed / 4 * 100).toStringAsFixed(0)}%'),
                icon: const Icon(Icons.wind_power),
              ),
            ),
          ]),
        );
      },
    );
  }
}
