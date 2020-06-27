import 'package:flutter/material.dart';

class SatisfactionPage extends StatefulWidget{
  @override
  _SatisfactionPageState createState() => _SatisfactionPageState();
}
  
class _SatisfactionPageState extends State<SatisfactionPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          children: <Widget>[
            Text(
              'ความพึงพอใจต่อการให้บริการ',
              style: TextStyle(
                fontSize: 20.0,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3.5
                  ..color = Colors.black,
              ),
            ), 
            Text(
              'ความพึงพอใจต่อการให้บริการ',
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