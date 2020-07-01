import 'package:flutter/material.dart';

class ManageBusstop extends StatefulWidget {
  ManageBusstop({Key key}) : super(key: key);

  @override
  _ManageBusstopState createState() => _ManageBusstopState();
}

class _ManageBusstopState extends State<ManageBusstop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จัดการจัดรับส่งผู้โดยสาร',
          textScaleFactor: 1.2,
          style: TextStyle(
            color: Color(0xFF3a3a3a),
          ),
        ),
      ),
    );
  }
}
