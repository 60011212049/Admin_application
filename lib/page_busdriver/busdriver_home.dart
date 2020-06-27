import 'package:adminapp/model/busdriver_model.dart';
import 'package:flutter/material.dart';

class BusdriverHome extends StatefulWidget {

  static List<BusdriverModel> busdriverModel = List<BusdriverModel>();

  @override
  _BusdriverHomeState createState() => _BusdriverHomeState();
}

class _BusdriverHomeState extends State<BusdriverHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Stack(
            children: <Widget>[
              Text(
                'คนขับรถ',
                style: TextStyle(
                  fontSize: 20.0,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3.5
                    ..color = Colors.black,
                ),
              ),
              Text(
                'คนขับรถ',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.yellow[700],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Icon(Icons.person)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                        child: Text(
                          'แก้ไขข้อมูลส่วนตัว',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18.0,
                          ),
                        ),
                        onPressed: () {}),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: Stack(
                            children: <Widget>[
                              Text(
                                'ชื่อ : ',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3
                                    ..color = Colors.black,
                                ),
                              ),
                              Text(
                                'ชื่อ : ',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                          child: Stack(
                            children: <Widget>[
                              Text(
                                'เบอร์โทร : ',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3
                                    ..color = Colors.black,
                                ),
                              ),
                              Text(
                                'เบอร์โทร : ',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide(color: Colors.yellow[700]),
                            ),
                            color: Colors.yellow[200],
                            textColor: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.star),
                                  Stack(
                                    children: <Widget>[
                                      Text(
                                        'ความพึงพอใจต่อการใช้บริการ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 0.75
                                            ..color = Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'ความพึงพอใจต่อการใช้บริการ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/satisfaction-page');
                            }),
                      ),
                      SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide(color: Colors.yellow[700]),
                            ),
                            color: Colors.yellow[200],
                            textColor: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.calendar_today),
                                  Stack(
                                    children: <Widget>[
                                      Text(
                                        'ตารางการทำงานของคนขับ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 0.75
                                            ..color = Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'ตารางการทำงานของคนขับ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/worktable-page');
                            }),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      width: 150.0,
                      height: 120.0,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(color: Colors.yellow[700]),
                          ),
                          color: Colors.yellow[200],
                          textColor: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.settings_power),
                                Stack(
                                  children: <Widget>[
                                    Text(
                                      'ออกจากระบบ',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 0.75
                                          ..color = Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'ออกจากระบบ',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          onPressed: () {
                            //Navigator.pushNamed(context, '/');
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}