import 'package:flutter/material.dart';

class Constants {
  static const devMode = true;
  static const accelerometerCollection = 'accelerometer';

  static const List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(value: '15', child: Text('15 minutes')),
    DropdownMenuItem(value: '30', child: Text('30 minutes')),
    DropdownMenuItem(value: '60', child: Text('1 hour')),
    DropdownMenuItem(value: '120', child: Text('2 hour')),
    DropdownMenuItem(value: '240', child: Text('4 hour')),
    DropdownMenuItem(value: '480', child: Text('8 hour')),
  ];
}

enum ARGS {
  USER,
  ACCELEROMETER,
}
