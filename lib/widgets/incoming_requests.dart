import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  static const _fontSize = 24.0;
  static const requestBoxWidth = 360.0;

  final ButtonStyle _requestFlagStyle = OutlinedButton.styleFrom(
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
        // _fanSpeed = airStatusList[0].data()['speed'];

        _requestTimeTemp = airStatusList[0].data()['tempCreatedAt'];
        _requestVisibleTemp = _currentTimeTemp < _requestTimeTemp;

        _requestTimeFan = airStatusList[0].data()['fanCreatedAt'];
        _requestVisibleFan = _currentTimeFan < _requestTimeFan;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Visibility(
                  visible: _requestVisibleTemp,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: SizedBox(
                    width: requestBoxWidth,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          if (DateTime.now().millisecondsSinceEpoch >
                              _requestTimeTemp) {
                            _flipRequestVisibilityTemp();
                          }
                        });
                      },
                      style: _requestFlagStyle,
                      label: const Text('  New Temp'),
                      icon: const Icon(Icons.sunny_snowing),
                    ),
                  )),
              const SizedBox(height: 10),
              Visibility(
                  visible: _requestVisibleFan,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: SizedBox(
                    width: requestBoxWidth,
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
                        backgroundColor: Colors.blue.shade600,
                        textStyle: const TextStyle(fontSize: _fontSize),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      label: const Text('  New Speed'),
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
