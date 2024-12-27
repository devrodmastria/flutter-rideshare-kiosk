import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/data/data.dart';

class FirestoreMsg extends StatefulWidget {
  const FirestoreMsg({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FirestoreMsg();
  }
}

class _FirestoreMsg extends State<FirestoreMsg> {
  var message = 'oops';

  FirebaseFirestore FBstore = FirebaseFirestore.instance;

  Future<void> getMessage() async {
    try {
      await FBstore.collection('ride').get().then((newSnapshot) {
        for (var label in newSnapshot.docs) {
          if (label.id == 'custom_msg') {
            var newMsg = label['music'];
            message = newMsg;
          }
        }
      });
    } catch (e) {
      message = sliderNotes[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(
          fontSize: 48, color: Theme.of(context).colorScheme.onSurface),
      textAlign: TextAlign.center,
    );
  }
}
