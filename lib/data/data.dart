import 'package:flutter/material.dart';

const List<String> sliderHeaders = [
  'Hello!',
  'Music',
  'Climate Control',
  'Entertainment',
  'Health'
];

const List<String> sliderNotes = [
  'Welcome to your Rideshare Kiosk\n\nSwipe to explore!',
  'Play your music via Bluetooth\n\nOpen your phone and connect to JR-CB3',
  'Click below to make a request\n',
  'Select an app to enjoy! \n',
  'Items available upon request:\n\nWater & Trash Bag',
];

List<Color> sliderGradientStart = [
  Colors.blue.shade200.withOpacity(0.6), // default value

  //alternatives
  Colors.red.shade200.withOpacity(0.6),
  Colors.orange.shade200.withOpacity(0.6),
  Colors.yellow.shade200.withOpacity(0.6),
  Colors.green.shade200.withOpacity(0.6),
];

List<Color> sliderGradientEnd = [
  Colors.blue.shade900.withOpacity(0.6), // default value

  //alternatives
  Colors.red.shade600.withOpacity(0.6),
  Colors.orange.shade600.withOpacity(0.6),
  Colors.yellow.shade600.withOpacity(0.6),
  Colors.green.shade600.withOpacity(0.6),
];

enum AirStatus { cold, heat, off }
