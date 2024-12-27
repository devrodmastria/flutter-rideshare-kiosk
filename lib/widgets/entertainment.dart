import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Entertainment extends StatefulWidget {
  const Entertainment({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EntertainmentState();
  }
}

class _EntertainmentState extends State<Entertainment> {
  final ButtonStyle hyperlinkStyles = ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(16.0),
    foregroundColor: Colors.black,
    backgroundColor: Colors.white,
    textStyle: const TextStyle(fontSize: 36),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: hyperlinkStyles,
            child: const Text('D.I.A. Events'),
            onPressed: () => launchUrlString('https://dia.org/events'),
          ),
          const SizedBox(width: 24),
          ElevatedButton(
            style: hyperlinkStyles,
            child: const Text('Metro Times'),
            onPressed: () => launchUrlString('https://www.metrotimes.com/'),
          ),
          const SizedBox(width: 24),
          ElevatedButton(
            style: hyperlinkStyles,
            child: const Text('YouTube'),
            onPressed: () => launchUrlString('https://www.youtube.com/'),
          )
        ],
      ),
    );
  }
}
