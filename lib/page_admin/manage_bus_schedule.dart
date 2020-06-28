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
        title: Text('จัดการตารางการเดินรถ'),
      ),
    );
  }
}
