import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ManageBusSchedule extends StatefulWidget {
  @override
  _ManageBusScheduleState createState() => _ManageBusScheduleState();
}

class _ManageBusScheduleState extends State<ManageBusSchedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'จัดการตารางการเดินรถ',
        textScaleFactor: 1.2,
        style: TextStyle(
          color: Color(0xFF3a3a3a),
        ),
      )),
    );
  }
}
