
import 'package:flutter/material.dart';

class WorkTablePage extends StatefulWidget{
  @override
  _WorkTablePageState createState() => _WorkTablePageState();
}

class _WorkTablePageState extends State<WorkTablePage>{
  List list = ["test1","test2","test3","test4","test5","test6","test7"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Stack(
            children: <Widget>[
              Text(
                'ตารางการทำงานของคนขับ',
                style: TextStyle(
                  fontSize: 20.0,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3.5
                    ..color = Colors.black,
                ),
              ), 
              Text(
                'ตารางการทำงานของคนขับ',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.yellow[700],
                ),
              ),
            ], 
          ),
      ),

      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
          ],
        ),
      ),
    );
  }
}