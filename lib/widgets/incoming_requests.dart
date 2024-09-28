import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/data/data.dart';

class IncomingRequests extends StatefulWidget {
  const IncomingRequests({super.key});

  @override
  State<StatefulWidget> createState() {
    return _IncomingRequests();
  }
}

class _IncomingRequests extends State<IncomingRequests> {
  var _requestVisibleTemp = false;
  var _requestVisibleFan = false;

  var _requestTimeTemp = 0;
  var _requestTimeFan = 0;

  var _currentTimeTemp = 0;
  var _currentTimeFan = 0;

  String _tempStatus = AirStatus.cold.toString();
  var _fanSpeed = 1;
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
    backgroundColor: Colors.blue.shade400,
    textStyle: const TextStyle(fontSize: _fontSize),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );

  final ButtonStyle airBtnStyleOff = OutlinedButton.styleFrom(
    padding: const EdgeInsets.all(16),
    foregroundColor: Colors.black87,
    backgroundColor: Colors.grey.shade400,
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

  void _flipRequestVisibilityTemp() {
    _currentTimeTemp = DateTime.now().millisecondsSinceEpoch;
    _requestVisibleTemp = !_requestVisibleTemp;
  }

  void _flipRequestVisibilityFan() {
    _currentTimeFan = DateTime.now().millisecondsSinceEpoch;
    _requestVisibleFan = !_requestVisibleFan;
  }

  @override
  void initState() {
    super.initState();

    // hide old requests on launch
    _flipRequestVisibilityFan();
    _flipRequestVisibilityTemp();
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
        _tempStatus = airStatusList[0].data()['air'];
        _fanSpeed = airStatusList[0].data()['speed'];

        _requestTimeTemp = airStatusList[0].data()['tempCreatedAt'];
        _requestVisibleTemp = _currentTimeTemp < _requestTimeTemp;

        _requestTimeFan = airStatusList[0].data()['fanCreatedAt'];
        _requestVisibleFan = _currentTimeFan < _requestTimeFan;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                  visible: _requestVisibleTemp,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: SizedBox(
                    width: 300.0,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          if (DateTime.now().millisecondsSinceEpoch >
                              _requestTimeTemp) {
                            _flipRequestVisibilityTemp();
                          }
                        });
                      },
                      style: _tempStatus == AirStatus.cold.toString()
                          ? airBtnStyleCold
                          : _tempStatus == AirStatus.heat.toString()
                              ? airBtnStyleHeat
                              : airBtnStyleOff,
                      label: Text(_tempStatus == AirStatus.cold.toString()
                          ? 'A/C Requested'
                          : _tempStatus == AirStatus.heat.toString()
                              ? 'Heat Requested'
                              : 'Off Requested'),
                      icon: const Icon(Icons.sunny_snowing),
                    ),
                  )),
              const SizedBox(height: 30),
              Visibility(
                  visible: _requestVisibleFan,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: SizedBox(
                    width: 300.0,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          if (DateTime.now().millisecondsSinceEpoch >
                              _requestTimeFan) _flipRequestVisibilityFan();
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
        );
      },
    );
  }
}
