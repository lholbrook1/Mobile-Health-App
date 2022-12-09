import 'package:flutter/material.dart';

class Constants {
  static const devMode = true;
  static const accelerometerCollection = 'accelerometer';

  static const List<DropdownMenuItem<String>> collectMenuItems = [
    DropdownMenuItem(value: '1', child: Text('1 second')),
    DropdownMenuItem(value: '5', child: Text('5 seconds')),
    DropdownMenuItem(value: '30', child: Text('30 seconds')),
    DropdownMenuItem(value: '60', child: Text('1 minute')),
    DropdownMenuItem(value: '120', child: Text('2 minutes')),
    DropdownMenuItem(value: '240', child: Text('4 minutes')),
    DropdownMenuItem(value: '480', child: Text('8 minutes')),
  ];

  static const List<DropdownMenuItem<String>> sendMenuItems = [
    DropdownMenuItem(value: '6', child: Text('5 seconds')),
    DropdownMenuItem(value: '16', child: Text('15 seconds')),
    DropdownMenuItem(value: '31', child: Text('30 seconds')),
    DropdownMenuItem(value: '61', child: Text('1 minute')),
    DropdownMenuItem(value: '121', child: Text('2 minutes')),
    DropdownMenuItem(value: '241', child: Text('4 minutes')),
    DropdownMenuItem(value: '481', child: Text('8 minutes')),
  ];
}

enum ARGS {
  USER,
  ACCELEROMETER,
  DATABASE,
}
