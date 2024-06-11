import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/data/data.dart';
import 'package:kiosk/widgets/clock.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class GuestRequest extends StatefulWidget {
  const GuestRequest({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GuestRequestState();
  }
}

class _GuestRequestState extends State<GuestRequest> {
  var _requestVisible = false;
  String _airStatus = AirStatus.cold.toString();
  var _fanSpeed = 1;
  var _requestTimestamp = 0;
  var _currentTimestamp = 0;
  static const _fontSize = 24.0;

  final ButtonStyle airBtnStyleHeat = OutlinedButton.styleFrom(
    padding: const EdgeInsets.all(16),
    foregroundColor: Colors.white,
    backgroundColor: Colors.red.shade400,
    textStyle: const TextStyle(fontSize: _fontSize),
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
    textStyle: const TextStyle(fontSize: _fontSize),
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
    textStyle: const TextStyle(fontSize: _fontSize),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );

  final ButtonStyle speedBtnStyleLow = OutlinedButton.styleFrom(
    padding: const EdgeInsets.all(16),
    foregroundColor: Colors.white,
    backgroundColor: Colors.green.shade400,
    textStyle: const TextStyle(fontSize: _fontSize),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );

  final ButtonStyle speedBtnStyleHigh = OutlinedButton.styleFrom(
    padding: const EdgeInsets.all(16),
    foregroundColor: Colors.white,
    backgroundColor: Colors.green.shade900,
    textStyle: const TextStyle(fontSize: _fontSize),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );

  void _flipRequestVisibility() {
    _currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    _requestVisible = !_requestVisible;
  }

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

        _requestTimestamp = airStatusList[0].data()['createdAt'];
        _requestVisible = _currentTimestamp < _requestTimestamp;

        return Scaffold(
            appBar: AppBar(),
            backgroundColor: Colors.yellow.shade200,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ClockTool(),
                  const SizedBox(
                    height: 80,
                  ),
                  Visibility(
                      visible: _requestVisible,
                      maintainState: true,
                      maintainAnimation: true,
                      maintainSize: true,
                      child: SizedBox(
                        width: 300.0,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              if (DateTime.now().millisecondsSinceEpoch >
                                  _requestTimestamp) _flipRequestVisibility();
                            });
                          },
                          style: _airStatus == AirStatus.cold.toString()
                              ? airBtnStyleCold
                              : _airStatus == AirStatus.heat.toString()
                                  ? airBtnStyleHeat
                                  : airBtnStyleOff,
                          label: Text(_airStatus == AirStatus.cold.toString()
                              ? 'A/C Requested'
                              : _airStatus == AirStatus.heat.toString()
                                  ? 'Heat Requested'
                                  : 'Off Requested'),
                          icon: const Icon(Icons.sunny_snowing),
                        ),
                      )),
                  const SizedBox(height: 30),
                  Visibility(
                      visible: _requestVisible,
                      maintainState: true,
                      maintainAnimation: true,
                      maintainSize: true,
                      child: SizedBox(
                        width: 300.0,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              if (DateTime.now().millisecondsSinceEpoch >
                                  _requestTimestamp) _flipRequestVisibility();
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            foregroundColor: Colors.white,
                            backgroundColor: _fanSpeed == 1
                                ? Colors.orange.shade600
                                : _fanSpeed == 2
                                    ? Colors.blue.shade600
                                    : _fanSpeed == 3
                                        ? Colors.pink.shade600
                                        : Colors.purple.shade600,
                            textStyle: const TextStyle(fontSize: _fontSize),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          label: Text('Speed $_fanSpeed requested'),
                          icon: const Icon(Icons.wind_power),
                        ),
                      )),
                ],
              ),
            ));
      },
    );
  }
}
