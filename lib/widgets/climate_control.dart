import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/data/data.dart';
import 'package:flutter/cupertino.dart';

class ClimateControl extends StatefulWidget {
  const ClimateControl({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ClimateControlState();
  }
}

class _ClimateControlState extends State<ClimateControl> {
  final ButtonStyle airSpeedBtnStyle = OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    foregroundColor: Colors.black87,
    backgroundColor: Colors.white70,
    textStyle: const TextStyle(fontSize: 36),
    shape: RoundedRectangleBorder(
      side: BorderSide(width: 5.0, color: Colors.blue.shade800),
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

  void _sendTempRequest(String temp) async {
    _airStatus = temp;

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
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CupertinoSegmentedControl(
              selectedColor: Colors.blue.shade800,
              unselectedColor: Colors.white,
              groupValue: _airStatus,
              borderColor: Colors.blue.shade800,
              onValueChanged: (String value) {
                setState(() {
                  _airStatus = value;
                  _sendTempRequest(value);
                });
              },
              children: {
                AirStatus.cold.toString(): Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'A/C',
                    style: TextStyle(fontSize: 36),
                  ),
                ),
                AirStatus.heat.toString(): Container(
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      'Heat',
                      style: TextStyle(fontSize: 36),
                    )),
                AirStatus.off.toString(): Container(
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      'Off',
                      style: TextStyle(fontSize: 36),
                    )),
              },
            ),
            const SizedBox(height: 24),
            Visibility(
              visible: (_airStatus != AirStatus.off.toString()),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: SizedBox(
                width: 350.0,
                child: ElevatedButton.icon(
                  onPressed: () {
                    (_airStatus != AirStatus.off.toString())
                        ? _sendSpeedRequest()
                        : null;
                  },
                  style: airSpeedBtnStyle,
                  label: Text(
                      'Fan speed: ${(_fanSpeed / 4 * 100).toStringAsFixed(0)}%'),
                  icon: const Icon(Icons.wind_power),
                ),
              ),
            )
          ]),
        );
      },
    );
  }
}
