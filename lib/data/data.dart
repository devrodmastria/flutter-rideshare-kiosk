import 'package:flutter/material.dart';

const List<String> sliderHeaders = [
  'Hello!',
  'Music',
  'Climate Control',
  'Entertainment',
  'HELP'
];

const List<String> sliderNotes = [
  '\nWelcome to your Rideshare Kiosk\n\nSwipe to explore! ',
  'Play music via Bluetooth\n\nConnect your phone to JR-CB3',
  'Click below to make a request\n...or ask me directly\n',
  'Select an app to enjoy! \n',
  'Water \n Nausea Bag \n\n available upon request',
];

List<Color> sliderColorA = [
  Colors.red.shade400.withOpacity(0.6),
  Colors.orange.shade400.withOpacity(0.6),
  Colors.yellow.shade400.withOpacity(0.6),
  Colors.lightBlue.withOpacity(0.6),
  Colors.lightGreen.withOpacity(0.6),
];

List<Color> sliderColorB = [
  Colors.lightBlue.withOpacity(0.6),
  Colors.lightGreen.withOpacity(0.6),
  Colors.purple.shade400.withOpacity(0.6),
  Colors.orange.shade400.withOpacity(0.6),
  Colors.red.shade400.withOpacity(0.6),
];

enum AirStatus { cold, heat, off }
