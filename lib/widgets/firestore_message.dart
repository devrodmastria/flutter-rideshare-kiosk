import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreMsg extends StatefulWidget {
  const FirestoreMsg({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FirestoreMsg();
  }
}

class _FirestoreMsg extends State<FirestoreMsg> {
  var musicMessage = 'oops';

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
        musicMessage = airStatusList[1].data()['music'];

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 200),
            child: Text(
              musicMessage,
              style: TextStyle(
                  fontSize: 36, color: Theme.of(context).colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
