import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                  'Welcome to your Lyft Kiosk!\n\nUse the tabs below to explore\nride features.'),
              SizedBox(height: 100),
              Text(
                'Enjoy your trip!\n-Rod',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
