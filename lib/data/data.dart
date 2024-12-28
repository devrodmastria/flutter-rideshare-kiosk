import 'package:flutter/material.dart';

const List<String> sliderHeaders = [
  'Hello!', //0
  'Music', //1
  'Entertainment', //2
  'Climate Control', //3
  'Water'
];

const List<String> sliderNotes = [
  'Welcome to your Rideshare Kiosk\n\nSwipe to explore!',
  'Connect your phone',
  'Select an app to enjoy!\n',
  'Cabin settings\n',
  'Water available upon request\n\nTrash bag located under power outlet',
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

enum FanStatus { slow, medium, high, max }
