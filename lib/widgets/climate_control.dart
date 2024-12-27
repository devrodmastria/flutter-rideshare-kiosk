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
  var _airStatus = AirStatus.cold.toString();
  var _fanSpeed = FanStatus.slow.toString();

  void _sendSpeedRequest(String newFan) async {
    _fanSpeed = newFan;

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
          child: Column(children: [
            //Fan Mode Widgets
            Column(
              children: [
                CupertinoSegmentedControl(
                  selectedColor: Colors.blue.shade800,
                  unselectedColor: Colors.white,
                  groupValue: _airStatus,
                  borderColor: Colors.white,
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
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    AirStatus.heat.toString(): Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          'Heat',
                          style: TextStyle(fontSize: 30),
                        )),
                    AirStatus.off.toString(): Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          'Off',
                          style: TextStyle(fontSize: 30),
                        )),
                  },
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Mode',
                  style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Fan Speed Widgets
            Visibility(
              visible: (_airStatus != AirStatus.off.toString()),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Column(
                children: [
                  CupertinoSegmentedControl(
                    selectedColor: Colors.blue.shade800,
                    unselectedColor: Colors.white,
                    groupValue: _fanSpeed,
                    borderColor: Colors.white,
                    onValueChanged: (String value) {
                      setState(() {
                        (_airStatus != AirStatus.off.toString())
                            ? _sendSpeedRequest(value)
                            : null;
                      });
                    },
                    children: {
                      FanStatus.slow.toString(): Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 4.0),
                        child: const Text(
                          'slow',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      FanStatus.medium.toString(): Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 4.0),
                          child: const Text(
                            'medium',
                            style: TextStyle(fontSize: 30),
                          )),
                      FanStatus.high.toString(): Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 4.0),
                          child: const Text(
                            'high',
                            style: TextStyle(fontSize: 30),
                          )),
                      FanStatus.max.toString(): Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: .0),
                          child: const Text(
                            'max',
                            style: TextStyle(fontSize: 30),
                          )),
                    },
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Fan Speed',
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.normal,
                        color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ]),
        );
      },
    );
  }
}
